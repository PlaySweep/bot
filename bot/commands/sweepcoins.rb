module Commands
  def sweepcoins
    @api = Api.new
    @api.find_or_create('users', user.id)
    @api.user.data.sweep_coins == 1 ? sweepcoins = 'Sweepcoin' : sweepcoins = 'Sweepcoins'
    if @api.user.data.sweep_coins >= 30
      options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of high balance initial responses
      @api.user.current_streak > 0 ? quick_replies = [["Earn coins", "Earn coins"], ["Eh, I'm good", "I'm good"]] : quick_replies = [["Use lifeline", "Use lifeline"], ["Earn coins", "Earn coins"], ["Eh, I'm good", "I'm good"]]
      message.typing_on
      say options.sample
      sleep 1
      message.typing_on
      sleep 1.5
      say "I currently see #{@api.user.data.sweep_coins} #{sweepcoins} in your wallet 🤑"
      sleep 1
      message.typing_on
      sleep 0.5
      say "What else can I help you with?", quick_replies: quick_replies
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

  def sweepcoins_for_postback
    @api = Api.new
    @api.find_or_create('users', user.id)
    @api.user.data.sweep_coins == 1 ? sweepcoins = 'Sweepcoin' : sweepcoins = 'Sweepcoins'
    if @api.user.data.sweep_coins >= 30
      options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of high balance initial responses
      @api.user.current_streak > 0 ? quick_replies = [["Earn coins", "Earn coins"], ["Eh, I'm good", "I'm good"]] : quick_replies = [["Use lifeline", "Use lifeline"], ["Earn coins", "Earn coins"], ["Eh, I'm good", "I'm good"]]
      postback.typing_on
      say options.sample
      sleep 1
      postback.typing_on
      sleep 1.5
      say "I currently see #{@api.user.data.sweep_coins} #{sweepcoins} in your wallet 🤑"
      sleep 1
      postback.typing_on
      sleep 0.5
      say "What else can I help you with?", quick_replies: quick_replies
      stop_thread
    else
      if @api.user.previous_streak > @api.user.current_streak
        options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of low balance initial responses
        postback.typing_on
        say options.sample
        sleep 1
        postback.typing_on
        sleep 1.5
        say "I currently see #{@api.user.data.sweep_coins} #{sweepcoins} in your wallet 🤑"
        sleep 1
        postback.typing_on
        sleep 0.5
        say "To use a lifeline and reset your streak back to #{@api.user.previous_streak}, you'll need at least 30 Sweepcoins", quick_replies: [["Earn more coins", "Earn more coins"], ["Select picks", "Select picks"]]
        stop_thread
      else
        options = ["Let's see here 🤔", "One moment, I'm counting 💰", "Beep boop bleep 🤖"] # collection of low balance initial responses
        postback.typing_on
        say options.sample
        sleep 1
        postback.typing_on
        sleep 1.5
        say "I currently see #{@api.user.data.sweep_coins} #{sweepcoins} in your wallet 🤑", quick_replies: [["Sweep store", "Sweep store"], ["Earn more coins", "Earn more coins"], ["Select picks", "Select picks"]]
        stop_thread
      end
    end
  end

  def sweep_store
    @api = Api.new
    @api.find_or_create('users', user.id)
    if @api.user.data.store_touched
      if @api.user.data.sweep_coins >= 30 && (@api.user.previous_streak > @api.user.current_streak)
        options = ["We are open 24/7 🏪", "Hold up, let me find the keys 🔑"]
        message.typing_on
        sleep 1.5
        say options.sample
        sleep 1
        message.typing_on
        sleep 1
        say "Use a lifeline to set your streak back to #{@api.user.previous_streak} for 30 Sweepcoins 🙏", quick_replies: [["Use lifeline", "Use lifeline"], ["Select picks", "Select picks"], ["Status", "Status"]]
        stop_thread
      elsif @api.user.data.sweep_coins < 30 && (@api.user.previous_streak > @api.user.current_streak)
        options = ["We are open 24/7 🏪", "Hold up, let me find the keys 🔑"]
        coins_needed = (30 - @api.user.data.sweep_coins)
        message.typing_on
        sleep 1.5
        say options.sample
        sleep 1
        message.typing_on
        sleep 1
        say "You only need #{coins_needed} more Sweepcoins to set your streak back to #{@api.user.previous_streak} 👌", quick_replies: [["Earn more coins", "Earn more coins"], ["Select picks", "Select picks"], ["Status", "Status"]]
        stop_thread
      else
        options = ["We are open 24/7 🏪", "Hold up, let me find the keys 🔑"]
        message.typing_on
        sleep 1.5
        say options.sample
        sleep 1
        message.typing_on
        sleep 1
        say "A lifeline is worth 30 coins and will reset you back to your previous streak, keeping your Sweep dreams alive 🙏", quick_replies: [["Use lifeline", "Use lifeline"], ["Select picks", "Select picks"], ["Status", "Status"]]
        stop_thread
      end
    else
      set('store touched', user.id)
      message.typing_on
      sleep 1.5
      say "Welcome to the Sweep store!"
      sleep 1
      message.typing_on
      sleep 1
      say "We are a small shop right now, so all we offer are lifelines."
      sleep 1
      message.typing_on
      sleep 2
      say "A lifeline is worth 30 coins and will reset you back to your previous streak, keeping your Sweep dreams alive 🙏", quick_replies: [["Use lifeline", "Use lifeline"], ["Select picks", "Select picks"], ["Status", "Status"]]
      stop_thread
    end
  end

  def earn_coins
    message.typing_on
    sleep 1
    say "🌞 Daily pick = 1 coin"
    sleep 1
    message.typing_on
    sleep 1
    say "👯 Refer a friend = 10 coins"
    sleep 1
    message.typing_on
    sleep 1
    say "🎉 Hit a Sweep = 10 coins", quick_replies: [["Sweep store", "Sweep store"], ["Select picks", "Select picks"], ["🎉 Share", "🎉 Share"]]
    stop_thread
  end
end