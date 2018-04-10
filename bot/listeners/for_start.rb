require 'mixpanel-ruby'

def listen_for_start_postback
  bind 'START' do
    begin
      @api = Api.new
      @api.find_or_create('users', user.id)
      if postback.referral
        referrer_id = postback.referral.ref
        puts "New User Id: #{user.id}"
        puts "Referrer Id: #{referrer_id}"
        update_referrer(referrer_id) unless referrer_id.to_i == 0
      end
      text = "Hey #{@api.user.first_name}, you finally found me!"
      postback.typing_on
      say text, quick_replies: [["Hi, Emma!", "WELCOME"]]
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