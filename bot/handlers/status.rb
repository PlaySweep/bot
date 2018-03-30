module Commands
  def handle_status
    @api = Api.new
    @api.find_or_create('users', user.id)
    message.typing_on
    quick_replies = ["My picks", "Sweepcoins"]
    if @api.user.current_streak > 0
      say STATUS_HOT.sample
      sleep 0.5
      message.typing_on
      sleep 1.5
      say "Your current streak sits at #{@api.user.current_streak}", quick_replies: quick_replies
      stop_thread
    else
      if !@api.user.data.status_touched # if hasnt been touched yet
        set('status touched', user.id)
        if @api.user.data.sweep_coins >= 30
          quick_replies = ["My picks", "Sweepcoins"]
          say "Goose 🥚"
          sleep 0.5
          if @api.user.previous_streak == @api.user.current_streak
            message.typing_on
            sleep 1.5
            say "You're currently at a streak of zero...", quick_replies: quick_replies
            stop_thread
          elsif @api.user.previous_streak <= @api.user.current_streak
            message.typing_on
            sleep 1.5
            say "You're currently at a streak of zero...", quick_replies: quick_replies
            stop_thread
          else
            quick_replies = ["Use lifeline", "My picks", "Sweepcoins"]
            sleep 0.5
            message.typing_on
            sleep 2
            say "But I have good news, you have #{@api.user.data.sweep_coins} Sweepcoins 🤑"
            sleep 0.5
            message.typing_on
            sleep 3
            say "Turn back the 🕗 to your previous streak of #{@api.user.previous_streak} by trading in 30 Sweepcoins for a lifeline", quick_replies: quick_replies
            stop_thread
          end
        else
          quick_replies = ["My picks", "Sweepcoins"]
          coins_needed = (30 - @api.user.data.sweep_coins)
          say "Goose 🥚"
          sleep 0.5
          message.typing_on
          sleep 1.5
          say "You're currently at a streak of zero."
          sleep 0.5
          message.typing_on
          @api.user.data.sweep_coins == 1 ? sweepcoins = 'Sweepcoin' : sweepcoins = 'Sweepcoins'
          sleep 2
          say "You only need #{coins_needed} more Sweepcoins to set your streak back to #{@api.user.previous_streak} 👌", quick_replies: quick_replies
          stop_thread
        end
      else
        if @api.user.data.sweep_coins >= 30
          quick_replies = ["Use lifeline", "My picks", "Sweepcoins"]
          say "Goose 🥚"
          sleep 0.5
          message.typing_on
          sleep 1.5
          say "You're currently at a streak of zero.", quick_replies: quick_replies
          stop_thread
        else
          quick_replies = ["My picks", "Sweepcoins"]
          say "Goose 🥚"
          sleep 0.5
          message.typing_on
          sleep 1.5
          say "You're currently at a streak of zero.", quick_replies: quick_replies
          stop_thread
        end
        stop_thread
      end
    end
    message.typing_off
    stop_thread
  end

  def handle_status_postback
    @api = Api.new
    @api.find_or_create('users', user.id)
    postback.typing_on
    quick_replies = ["My picks", "Sweepcoins"]
    if @api.user.current_streak > 0
      say STATUS_HOT.sample
      sleep 0.5
      postback.typing_on
      sleep 1.5
      say "Your current streak sits at #{@api.user.current_streak}", quick_replies: quick_replies
      stop_thread
    else
      if !@api.user.data.status_touched # if hasnt been touched yet
        set('status touched', user.id)
        if @api.user.data.sweep_coins >= 30
          quick_replies = ["My picks", "Sweepcoins"]
          say "Goose 🥚"
          sleep 0.5
          if @api.user.previous_streak == @api.user.current_streak
            postback.typing_on
            sleep 1.5
            say "You're currently at a streak of zero...", quick_replies: quick_replies
            stop_thread
          elsif @api.user.previous_streak <= @api.user.current_streak
            postback.typing_on
            sleep 1.5
            say "You're currently at a streak of zero...", quick_replies: quick_replies
            stop_thread
          else
            quick_replies = ["Use lifeline", "My picks", "Sweepcoins"]
            sleep 0.5
            postback.typing_on
            sleep 2
            say "But I have good news, you have #{@api.user.data.sweep_coins} Sweepcoins 🤑"
            sleep 0.5
            postback.typing_on
            sleep 3
            say "Turn back the 🕗 to your previous streak of #{@api.user.previous_streak} by trading in 30 Sweepcoins for a lifeline", quick_replies: quick_replies
            stop_thread
          end
        else
          quick_replies = ["My picks", "Sweepcoins"]
          coins_needed = (30 - @api.user.data.sweep_coins)
          say "Goose 🥚"
          sleep 0.5
          postback.typing_on
          sleep 1.5
          say "You're currently at a streak of zero."
          sleep 0.5
          postback.typing_on
          @api.user.data.sweep_coins == 1 ? sweepcoins = 'Sweepcoin' : sweepcoins = 'Sweepcoins'
          sleep 2
          say "You only need #{coins_needed} more Sweepcoins to set your streak back to #{@api.user.previous_streak} 👌", quick_replies: quick_replies
          stop_thread
        end
      else
        if @api.user.data.sweep_coins >= 30
          quick_replies = ["Use lifeline", "My picks", "Sweepcoins"]
          say "Goose 🥚"
          sleep 0.5
          postback.typing_on
          sleep 1.5
          say "You're currently at a streak of zero.", quick_replies: quick_replies
          stop_thread
        else
          quick_replies = ["My picks", "Sweepcoins"]
          say "Goose 🥚"
          sleep 0.5
          postback.typing_on
          sleep 1.5
          say "You're currently at a streak of zero.", quick_replies: quick_replies
          stop_thread
        end
        stop_thread
      end
    end
    postback.typing_off
    stop_thread
  end
end