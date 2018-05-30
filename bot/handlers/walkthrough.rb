module Commands
  def handle_walkthrough
    @api = Api.new
    @api.fetch_user(user.id)
    #TODO update copy and refactor for wins and losing streaks
    case message.quick_reply
    when 'WELCOME'
      medium_wait(:message)
      say "So how does all this stuff work? Simple."
      short_wait(:message)
      say "I send you games to pick and you try to hit 4 in a row 🚣‍♀️\n\n4 wins? Yup. 4 losses? Count that too 😇\n\n4 in a row of anything deserves some Amazon 💰, imo 😎", quick_replies: ["How much?"]
      next_command :handle_walkthrough
    when 'HOW MUCH?'
      message.typing_on
      say "The winners of these 'Sweeps' will split a daily pot of $25 🤑"
      short_wait(:message)
      say "I usually send out about $2-5 to winners each day...it's hard work, but I love it ❤️\n\nYou ready #{@api.user.first_name}? Don't worry, I'm just a tap or text away in case you need me 👍", quick_replies: [["Start Sweeping 🎉", "SELECT PICKS"]]
      stop_thread
    else
      redirect(:start)
      stop_thread
    end
  end
end