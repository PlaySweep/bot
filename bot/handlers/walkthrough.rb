module Commands
  def handle_walkthrough
    @api = Api.new
    @api.fetch_user(user.id)
    case message.quick_reply
    when 'WELCOME'
      medium_wait(:message)
      say "So how does all this stuff work? Simple."
      short_wait(:message)
      say "Pick 4 straight W's to hit a Sweep ✨", quick_replies: [["What do I win?", "HOW MUCH?"]]
      next_command :handle_walkthrough
    when 'HOW MUCH?'
      short_wait(:message)
      say "A daily pot of 2500 Sweepcoins ($25) is split among winners at the end of the day 🤑", quick_replies: [["What are Sweepcoins?", "SWEEPCOINS?"]]
      next_command :handle_walkthrough
    when 'SWEEPCOINS?'
      short_wait(:message)
      say "100 Sweepcoins = $1 Amazon 💰\n\nIn addition to hitting a Sweep, you can earn coins through other achievements like daily picks and special streaks 🚀", quick_replies: [["Start Sweeping 🎉", "SELECT PICKS"]]
      stop_thread
    else
      redirect(:start)
      stop_thread
    end
  end
end