module Commands
  def handle_walkthrough
    case message.quick_reply
    when 'WELCOME'
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
      #TODO refactor for wins and losing streaks
      say "And when you hit 4 wins in a row, I'll send you a digital Amazon gift card 💰", quick_replies: ["How much?"]
      next_command :handle_walkthrough
    when 'HOW MUCH?'
      message.typing_on
      say "At the end of the day, I send out $25 worth of Amazon gift cards to winners. If there's more than 1 winner, you'll split the prize 🤑"
      sleep 1.5
      message.typing_on
      sleep 2.5
      say "On average, I send out about $3-5 per Sweep won...it's hard work, but I love it ❤️", quick_replies: [["Start Sweeping 🎉", "SELECT PICKS"]]
      stop_thread
    else
      redirect(:start)
      stop_thread
    end
  end
end