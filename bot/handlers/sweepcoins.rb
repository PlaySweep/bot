module Commands
  def handle_sweepcoins
    case message.quick_reply
    when 'SWEEPSTORE'
      handle_sweep_store
    when 'EARN COINS'
      handle_earn_coins
    end
  end

  def handle_sweep_store
    say "Sweepstore coming soon...I promise, you're gonna like it 🛍"
    stop_thread
  end

  def handle_earn_coins
    short_wait(:message)
    say "🌞 Pick daily for 1 coin\n👯 Refer a friend for 10 coins\n💪 Win challenges\n🎉 Hit a Sweep for 10 coins", quick_replies: ['Challenges', 'Invite friends']
    stop_thread
  end

end