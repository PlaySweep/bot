require_relative '../constants/status'

module Commands
  def start
    begin
      @api = Api.new
      @api.find_fb_user(user.id)
      puts "Facebook user found => #{@api.fb_user}"
      @api.find_or_create('users', user.id)
      postback.typing_on
      say "Hey #{@api.user.first_name}, you finally found me!", quick_replies: [ ["Hi, Emma!", "Welcome"] ]
      if postback.referral
        referrer_id = postback.referral.ref
        puts "Referrer Id: #{referrer_id}"
        update_sender(user.id, referrer_id) unless referrer_id.to_i == 0
      end
      stop_thread
      rescue NoMethodError => e
        say "Hmm 🤔..."
        postback.typing_on
        sleep 1.5
        postback.typing_on
        say "So I just tried to reach out to Facebook for some of your info and they seem to be having some issues."
        postback.typing_on
        sleep 0.5
        postback.typing_on
        say "...I'm Emma btw 👋, I'll keep a look out and let you know when we can get started 🎉"
        # send alert message
        stop_thread
    end
  end

  def walkthrough
    @api = Api.new
    @api.find_or_create('users', user.id)
    stop_thread and return if message.quick_reply.nil?
    case message.quick_reply
    when 'Welcome'
      message.typing_on
      say "😊"
      sleep 0.5
      message.typing_on
      sleep 1
      say "As you now know, I'm Emma! Your personal Sweep agent and the future of sports gaming 🤖"
      sleep 1
      message.typing_on
      sleep 1.5
      say "Every day from here on out, I'll send you a curated list of games to pick from, for free!"
      sleep 1
      message.typing_on
      sleep 1.5
      say "And when you hit 4 wins in a row, I'll send you a digital Amazon gift card 💰", quick_replies: [["How much?", "How much"]]
      next_command :walkthrough
    when 'How much'
      message.typing_on
      say "At the end of the day, I send out $25 worth of Amazon gift cards to winners. If there's more than 1 winner, you'll split the prize 🤑"
      sleep 1.5
      message.typing_on
      sleep 2.5
      say "On average, I send out about $8-12 per Sweep...it's hard work, but I love it ❤️"
      sleep 1
      message.typing_on
      sleep 1
      say "Amazon Prime here we come!", quick_replies: [["Start Sweeping 🎉", "Select picks"]]
      stop_thread
    else
      say "Oh trying to be sneaky huh? It's all good, I got you. Make your picks below!", quick_replies: [["NCAAB", "NCAAB"], ["NBA", "NBA"], ['MLB', 'MLB'] ["NHL", "NHL"]]
      stop_thread
    end
  end
end
