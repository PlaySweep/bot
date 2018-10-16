def listen_for_start_postback
  bind 'START' do
    begin
      sweepy = Sweep::User.find_or_create(user.id)
      say "Welcome to Budweiser Sweep #{sweepy.first_name} 👋"
      say "Help me curate the most interesting games by confirming your location 🏡", quick_replies: LOCATION_PROMPT
      # Sweep::User.find(postback.referral.ref).update_referral(sweepy.facebook_uuid) if postback.referral && postback.referral.ref.to_i != 0
      next_command :handle_lookup_location
    rescue NoMethodError => e
      sweepy = Sweep::User.create(user.id)
      puts "Error => #{e.inspect}"
      # say "Hi there 👋, Facebook is still retrieving some of your information for me, but I can wait on that 😉\n\nYou can get started on your streak by typing anything like 'make picks' or tapping the bubbles below 🎉", quick_replies: ['Select picks', 'Status']
      # if ENV['RACK_ENV'] == 'production'
      #   message_options = {
      #     messaging_type: "UPDATE",
      #     recipient: { id: 1827403637334265 },
      #     message: {
      #       text: "Get started error => \n\n#{e.inspect}\n\nUser: #{sweepy}\n\nUser id: #{sweepy.id}",
      #     }
      #   }
      #   Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
      # end
      stop_thread
    end
  end
end