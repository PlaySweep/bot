module Commands
  def handle_sweepcoins
    @api = Api.new
    @api.fetch_user(user.id)
    @api.user.data.sweep_coins == 1 ? sweepcoins = 'Sweepcoin' : sweepcoins = 'Sweepcoins'
    if @api.user.data.sweep_coins >= 30
      options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of high balance initial responses
      @api.user.current_streak > 0 ? quick_replies = [["Earn coins", "Earn coins"], ["Eh, I'm good", "I'm good"]] : quick_replies = [["Use lifeline", "Use lifeline"], ["Earn coins", "Earn coins"], ["Eh, I'm good", "I'm good"]]
      message.typing_on
      say options.sample
      sleep 1
      message.typing_on
      sleep 1.5
      say "I currently see #{@api.user.data.sweep_coins} #{sweepcoins} in your wallet 🤑", quick_replies: quick_replies
      stop_thread
    else
      if @api.user.previous_streak > @api.user.current_streak
        options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of low balance initial responses
        message.typing_on
        say options.sample
        sleep 1
        message.typing_on
        sleep 1.5
        say "I currently see #{@api.user.data.sweep_coins} #{sweepcoins} in your wallet 🤑"
        sleep 1
        message.typing_on
        sleep 0.5
        say "To use a lifeline and reset your streak back to #{@api.user.previous_streak}, you'll need at least 30 Sweepcoins", quick_replies: [["Earn more coins", "Earn more coins"], ["Select picks", "Select picks"]]
        stop_thread
      else
        options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of low balance initial responses
        message.typing_on
        say options.sample
        sleep 1
        message.typing_on
        sleep 1.5
        say "I currently see #{@api.user.data.sweep_coins} #{sweepcoins} in your wallet 🤑", quick_replies: [["Sweep store", "Sweep store"], ["Earn more coins", "Earn more coins"], ["Select picks", "Select picks"]]
        stop_thread
      end
    end
  end
end