module Commands
  def handle_status
    @api = Api.new
    @api.fetch_user(user.id)
    challenge_options = ["Challenges", "Challenge friends", "Challenge time?"]
    select_picks_options = ["Select picks", "Make picks", "Start pickin'"]
    if current_status == :winning_streak
      show_my_picks(:message)
      quick_replies = [{ content_type: 'text', title: select_picks_options.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: challenge_options.sample, payload: "CHALLENGE" }]
      text = build_text_for(resource: :status, object: @api.user, options: current_status)
      url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
      short_wait(:message)
      show_button("Show Status", text, quick_replies, url)
      stop_thread
    else
      if current_status == :should_use_lifeline
        show_my_picks(:message)
        quick_replies = [{ content_type: 'text', title: "Use lifeline", payload: "USE LIFELINE" }, { content_type: 'text', title: select_picks_options.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: challenge_options.sample, payload: "CHALLENGE" }]
        text = build_text_for(resource: :status, object: @api.user, options: current_status)
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:message)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      elsif current_status == :should_use_lifeline_but_cant
        show_my_picks(:message)
        quick_replies = [{ content_type: 'text', title: "Invite friends", payload: "INVITE FRIENDS" }, { content_type: 'text', title: select_picks_options.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: challenge_options.sample, payload: "CHALLENGE" }]
        text = build_text_for(resource: :status, object: @api.user, options: current_status)
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:message)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      elsif current_status == :losing_streak
        show_my_picks(:message)
        quick_replies = [{ content_type: 'text', title: select_picks_options.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: challenge_options.sample, payload: "CHALLENGE" }]
        text = build_text_for(resource: :status, object: @api.user, options: current_status)
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:message)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      else
        show_my_picks(:message)
        quick_replies = [{ content_type: 'text', title: select_picks_options.sample, payload: "SELECT PICKS" }]
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
    challenge_options = ["Challenges", "Challenge friends", "Challenge time?"]
    select_picks_options.sample = ["Pick em'", select_picks_options.sample, "Make picks", "Start pickin'"]
    if current_status == :winning_streak
      show_my_picks(:postback)
      quick_replies = [{ content_type: 'text', title: select_picks_options.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: challenge_options.sample, payload: "CHALLENGE" }]
      text = build_text_for(resource: :status, object: @api.user, options: current_status)
      url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
      short_wait(:postback)
      show_button("Show Status", text, quick_replies, url)
      stop_thread
    else
      if current_status == :should_use_lifeline
        show_my_picks(:postback)
        quick_replies = [{ content_type: 'text', title: "Use lifeline", payload: "USE LIFELINE" }, { content_type: 'text', title: select_picks_options.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: challenge_options.sample, payload: "CHALLENGE" }]
        text = build_text_for(resource: :status, object: @api.user, options: current_status)
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:postback)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      elsif current_status == :should_use_lifeline_but_cant
        show_my_picks(:postback)
        quick_replies = [{ content_type: 'text', title: "Invite friends", payload: "INVITE FRIENDS" }, { content_type: 'text', title: select_picks_options.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: challenge_options.sample, payload: "CHALLENGE" }]
        text = build_text_for(resource: :status, object: @api.user, options: current_status)
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:postback)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      elsif current_status == :losing_streak
        show_my_picks(:postback)
        quick_replies = [{ content_type: 'text', title: select_picks_options.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: challenge_options.sample, payload: "CHALLENGE" }]
        text = build_text_for(resource: :status, object: @api.user, options: current_status)
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:postback)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      else
        show_my_picks(:postback)
        quick_replies = [{ content_type: 'text', title: select_picks_options.sample, payload: "SELECT PICKS" }]
        text = "I'm still waiting to process one of your results, so for now your streak remains at 0 ☺️"
        url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
        short_wait(:postback)
        show_button("Show Status", text, quick_replies, url)
        stop_thread
      end
    end
  end

  def show_my_picks type
    @api.fetch_picks(user.id, :in_flight)
    medium_wait(type)
    if @api.picks.size != 0
      text = build_text_for(resource: :picks, object: @api.picks)
      say text
      short_wait(type)
    else
      say "You have no upcoming games 😲"
      short_wait(type)
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