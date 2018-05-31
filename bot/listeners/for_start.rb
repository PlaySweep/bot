def listen_for_start_postback
  bind 'START' do
    begin
      @api = Api.new
      @api.find_or_create('users', user.id)
      update_referrer(postback.referral.ref) if postback.referral && postback.referral.ref.to_i != 0
      say "Welcome to Sweep #{@api.user.first_name}, my name is Emma 👋"
      short_wait(:postback)
      say "If you're here to pick winners, challenge your friends, and earn some 💰...then I'm your bot 😉", quick_replies: [["Heck yeah!", "WELCOME"]]
      next_command :handle_walkthrough
    rescue NoMethodError => e
      puts "Error: #{e.inspect}"
      say "Hmm 🤔..."
      postback.typing_on
      sleep 1.5
      postback.typing_on
      say "I just tried to reach out to Facebook for some of your info and they seem to be having some issues."
      postback.typing_on
      sleep 0.5
      postback.typing_on
      say "...I'm Emma btw 👋"
      sleep 0.5
      postback.typing_on
      say "While I take care of all that for you, go ahead and get started below by typing 'Select picks'"
      stop_thread
    end
  end
end