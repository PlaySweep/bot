def listen_for_start_postback
  bind 'START' do
    begin
      @api = Api.new
      @api.find_or_create('users', user.id)
      sleep 2
      say "Welcome to Sweep #{@api.user.first_name}, my name is Emma 👋"
      short_wait(:postback)
      say "If you're here to pick winners, challenge your friends, and earn some 💰...then I'm your bot 😉", quick_replies: [["Heck yeah!", "WELCOME"]]
      update_referrer(postback.referral.ref) if postback.referral && postback.referral.ref.to_i != 0
      next_command :handle_walkthrough
    rescue NoMethodError => e
      puts "GET STARTED ERROR => #{e.inspect}"
      params = { :user => {:facebook_uuid => user.id} }
      @api.create('users', user.id, params)
      short_wait(:postback)
      say "Hi there 👋, Facebook is still retrieving some of your information for me, but I can wait on that 😉\n\nYou can get started on your streak by typing anything like 'make picks' or tapping the bubbles below 🎉", quick_replies: ['Select picks', 'Status']
      if ENV['RACK_ENV'] == 'production'
        message_options = {
          messaging_type: "UPDATE",
          recipient: { id: 1827403637334265 },
          message: {
            text: "Get started error => \n\n#{e.inspect}\n\nUser: #{@api.user}\n\nUser id: #{user.id}",
          }
        }
        Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
      end
      stop_thread
    end
  end
end