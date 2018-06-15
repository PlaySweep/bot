module Commands
  def handle_sweepcoins
    say "In case you need a reminder, the best ways to earn coins are to invite your friends, stay active, and WIN challenges against your friends 🏆", quick_replies: ['Invite friends', 'Challenges', 'Make picks'] and stop_thread and return if !message.quick_reply
    case message.quick_reply
    when 'SWEEPSTORE'
      handle_sweep_store
    when 'EARN COINS'
      handle_earn_coins
    end
  end

  def handle_sweep_store
    say "Sweepstore coming soon...I promise, you're gonna like it 🛍", quick_replies: ['Make picks', 'Status', 'Challenges']
    stop_thread
  end

  def handle_earn_coins
    short_wait(:message)
    say "I have big plans for how to use your Sweepcoins, but for now, I only offer lifelines to help you reset your streak..."
    medium_wait(:message)
    say "In the meantime, here are the ways you can keep earning more coins 😊\n\n🌞 Pick daily for 1 coin\n👯 Refer a friend for 10 coins\n💪 Win challenges\n🎉 Hit a Sweep for 10 coins", quick_replies: ['Challenges', 'Invite friends']
    stop_thread
  end

end