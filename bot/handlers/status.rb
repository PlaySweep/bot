module Commands
  def handle_status
    @api = Api.new
    @api.fetch_user(user.id)
    if current_status == :winning_streak
      quick_replies = [{ content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge friends", payload: "CHALLENGE" }]
      text = build_text_for(resource: :status, object: @api.user, options: current_status)
      url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
      short_wait(:message)
      show_button("Show Status", text, quick_replies, url)
      stop_thread
    else
      if current_status == :should_use_lifeline
        quick_replies = [{ content_type: 'text', title: "Use lifeline", payload: "USE LIFELINE" }, { content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge friends", payload: "CHALLENGE" }]
        text = build_text_for(resource: :status, object: @api.user, options: current_status)
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:message)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      elsif current_status == :should_use_lifeline_but_cant
        quick_replies = [{ content_type: 'text', title: "Invite friends", payload: "INVITE FRIENDS" }, { content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge friends", payload: "CHALLENGE" }]
        text = build_text_for(resource: :status, object: @api.user, options: current_status)
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:message)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      elsif current_status == :losing_streak
        quick_replies = [{ content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge friends", payload: "CHALLENGE" }]
        text = build_text_for(resource: :status, object: @api.user, options: current_status)
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:message)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      else
        quick_replies = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }]
        text = "I'm still waiting to process one of your results, so for now your streak remains at 0 ☺️"
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:message)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      end
    end
  end

  def handle_status_postback
    @api = Api.new
    @api.fetch_user(user.id)
    if current_status == :winning_streak
      quick_replies = [{ content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge friends", payload: "CHALLENGE" }]
      text = build_text_for(resource: :status, object: @api.user, options: current_status)
      url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
      short_wait(:postback)
      show_button("Show Status", text, quick_replies, url)
      stop_thread
    else
      if current_status == :should_use_lifeline
        quick_replies = [{ content_type: 'text', title: "Use lifeline", payload: "USE LIFELINE" }, { content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge friends", payload: "CHALLENGE" }]
        text = build_text_for(resource: :status, object: @api.user, options: current_status)
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:postback)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      elsif current_status == :should_use_lifeline_but_cant
        quick_replies = [{ content_type: 'text', title: "Invite friends", payload: "INVITE FRIENDS" }, { content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge friends", payload: "CHALLENGE" }]
        text = build_text_for(resource: :status, object: @api.user, options: current_status)
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:postback)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      elsif current_status == :losing_streak
        quick_replies = [{ content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge friends", payload: "CHALLENGE" }]
        text = build_text_for(resource: :status, object: @api.user, options: current_status)
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:postback)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      else
        quick_replies = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }]
        text = "I'm still waiting to process one of your results, so for now your streak remains at 0 ☺️"
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:postback)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      end
    end
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

  def current_status
    if user_has_win_streak?
      :winning_streak
    elsif user_has_losing_streak? && user_should_use_lifeline? && user_can_use_lifeline?
      :should_use_lifeline
    elsif user_has_losing_streak? && user_should_use_lifeline? && !user_can_use_lifeline?
      :should_use_lifeline_but_cant
    elsif user_has_losing_streak?
      :losing_streak
    end
  end
end