module Commands
  def handle_status
    @api = Api.new
    @api.fetch_user(user.id)
    quick_replies = ["My picks", "Sweepcoins", "Challenge a friend"]
    if user_is_hot?
      say STATUS_HOT.sample
      short_wait(:message)
      say "Your current streak is #{@api.user.current_streak}", quick_replies: quick_replies
      stop_thread
    else
      if user_should_use_lifeline?
        if user_can_use_lifeline?
          quick_replies = ["Use lifeline", "My picks", "Challenge a friend"]
          short_wait(:message)
          say "Your current streak is #{@api.user.current_streak}"
          medium_wait(:message)
          say "Wanna spend 30 Sweepcoins on a lifeline?\n\nI'll set your streak back to #{@api.user.previous_streak} 👍", quick_replies: quick_replies
          stop_thread and return
        else
          quick_replies = ["Invite friends", "Challenge a friend"]
          short_wait(:message)
          say "Your current streak is #{@api.user.current_streak}"
          long_wait(:message)
          say "You only need #{30 - @api.user.data.sweep_coins} more Sweepcoins to set your streak back to #{@api.user.previous_streak}\n\nInvite or challenge your friends for more!", quick_replies: quick_replies
          stop_thread and return
        end
      end
      say STATUS_COLD.sample
      short_wait(:message)
      say "Your current streak is #{@api.user.current_streak}"
      short_wait(:message)
      show_option(user.id, 'status')
      stop_thread
    end
  end

  def handle_status_postback
    @api = Api.new
    @api.fetch_user(user.id)
    quick_replies = ["My picks", "Sweepcoins", "Challenge a friend"]
    if user_is_hot?
      say STATUS_HOT.sample
      short_wait(:postback)
      say "Your current streak is #{@api.user.current_streak}", quick_replies: quick_replies
      stop_thread
    else
      if user_should_use_lifeline?
        if user_can_use_lifeline?
          quick_replies = ["Use lifeline", "My picks", "Challenge a friend"]
          short_wait(:postback)
          say "Your current streak is #{@api.user.current_streak}"
          medium_wait(:postback)
          say "Wanna spend 30 Sweepcoins on a lifeline?\n\nI'll set your streak back to #{@api.user.previous_streak} 👍", quick_replies: quick_replies
          stop_thread and return
        else
          quick_replies = ["Invite friends", "Challenge a friend"]
          short_wait(:postback)
          say "Your current streak is #{@api.user.current_streak}"
          long_wait(:postback)
          say "You only need #{30 - @api.user.data.sweep_coins} more Sweepcoins to set your streak back to #{@api.user.previous_streak}\n\nInvite or challenge your friends for more!", quick_replies: quick_replies
          stop_thread and return
        end
      end
      say STATUS_COLD.sample
      short_wait(:postback)
      say "Your current streak is #{@api.user.current_streak}"
      short_wait(:postback)
      show_option(user.id, 'status')
      stop_thread
    end
  end

  def user_is_hot?
    @api.user.current_streak > 0
  end

  def user_can_use_lifeline?
    @api.user.data.sweep_coins >= 30
  end

  def user_should_use_lifeline?
    previous, current = @api.user.previous_streak, @api.user.current_streak
    (previous != current && previous > current && previous % 4 != 0)
  end
end