module Commands
  def handle_status
    @api = Api.new
    @api.fetch_user(user.id)
    if user_has_win_streak?
      quick_replies = [{ content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge a friend", payload: "CHALLENGE A FRIEND" }]
      short_wait(:message)
      say STATUS_HOT.sample
      short_wait(:message)
      say "Your winning streak is #{@api.user.current_streak}"
      short_wait(:message)
      show_media_with_button(user.id, 'dashboard', DASHBOARD_IMAGE, quick_replies)
      stop_thread
    else
      if user_has_losing_streak? && user_should_use_lifeline? && user_can_use_lifeline?
        quick_replies = [{ content_type: 'text', title: "Use lifeline", payload: "USE LIFELINE" }, { content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge a friend", payload: "CHALLENGE A FRIEND" }]
        short_wait(:message)
        say "Your winning streak is #{@api.user.current_streak}"
        medium_wait(:message)
        say "Set yourself back to #{@api.user.previous_streak} with a lifeline\n\nOr travel the road to a Sweep starting with a losing streak of #{@api.user.current_losing_streak} 😝", quick_replies: quick_replies
        long_wait(:message)
        show_media_with_button(user.id, 'dashboard', DASHBOARD_IMAGE, quick_replies)
        stop_thread
      elsif user_has_losing_streak? && user_should_use_lifeline? && !user_can_use_lifeline?
        quick_replies = [{ content_type: 'text', title: "Invite friends", payload: "INVITE FRIENDS" }, { content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge a friend", payload: "CHALLENGE A FRIEND" }]
        short_wait(:message)
        say "Your winning streak is #{@api.user.current_streak}, but your losing streak is at #{@api.user.current_losing_streak}\n\n#{30 - @api.user.data.sweep_coins} more Sweepcoins and you could set your streak back to #{@api.user.previous_streak}\n\nInvite or challenge your friends for more!", quick_replies: quick_replies
        stop_thread
      elsif user_has_losing_streak?
        quick_replies = [{ content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge a friend", payload: "CHALLENGE A FRIEND" }]
        short_wait(:message)
        say STATUS_COLD.sample
        short_wait(:message)
        say "Your losing streak is #{@api.user.current_losing_streak}\n\nMaybe picking the opposite side works better hehe ☺️"
        short_wait(:message)
        show_media_with_button(user.id, 'dashboard', DASHBOARD_IMAGE, quick_replies)
        stop_thread
      else
        say "Once you make some picks, you'll have a winning/losing streak of something...", quick_replies: ["Select picks"]
        stop_thread
      end
    end
  end

  def handle_status_postback

  end

  def user_has_win_streak?
    @api.user.current_streak > 0 && @api.user.current_losing_streak < 1
  end

  def user_has_losing_streak?
    @api.user.current_streak < 1 && @api.user.current_losing_streak >= 1
  end

  def user_can_use_lifeline?
    @api.user.data.sweep_coins >= 30
  end

  def user_should_use_lifeline?
    previous, current, losing_streak = @api.user.previous_streak, @api.user.current_streak, @api.user.current_losing_streak
    (previous != 1 && previous != current && previous > current && previous % 4 != 0 && previous > losing_streak)
  end
end