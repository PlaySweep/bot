module Commands
  def handle_status
    @sweepy = Sweep::User.find(user.id)
    show_winning_sweep_message(:message) if current_status == :winning_sweep
    show_winning_streak(:message) if current_status == :winning_streak
    show_losing_streak(:message) if current_status == :losing_streak
    show_no_activity(:message) if current_status == :no_activity
  end

  def handle_status_postback
    @sweepy = Sweep::User.find(user.id)
    show_winning_sweep_message(:postback) if current_status == :winning_sweep
    show_winning_streak(:postback) if current_status == :winning_streak
    show_losing_streak(:postback) if current_status == :losing_streak
    show_no_activity(:postback) if current_status == :no_activity
  end

  def show_winning_sweep_message type
    if true
      @sweepy.update_status
      say "I got some updates for you #{@sweepy.first_name}, one sec ☝️"
      medium_wait(:message)
      quick_replies = [{ content_type: 'text', title: "Invite friends", payload: "INVITE FRIENDS" }, { content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }]
      text = "Since you've been gone, you won your last game and now have a streak of 3!"
      url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
      show_button("Show me more 🤗", text, quick_replies, url)
      stop_thread
    else
      quick_replies = [{ content_type: 'text', title: "Invite friends", payload: "INVITE FRIENDS" }, { content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }]
      @sweepy.streak == 1 ? dubs = "W" : dubs = "W's"
      text = "You're still at #{@sweepy.streak} in a row 🏁. Next up are the Falcons (+3.5) at 3p."
      url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
      show_button("Show me more 🤗", text, quick_replies, url)
      stop_thread
    end
  end

  def show_winning_streak type
    quick_replies = [{ content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }]
    text = "You are lit!"
    url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
    show_button("Show Status", text, quick_replies, url)
    stop_thread
  end

  def show_losing_streak type
    quick_replies = [{ content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }]
    text = "Losing has its perks too!"
    url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
    show_button("Show Status", text, quick_replies, url)
    stop_thread
  end

  def show_no_activity type
    quick_replies = [{ content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }]
    text = "I'm still waiting to process one of your results, so for now your streak remains at 0 ☺️"
    url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
    show_button("Show Status", text, quick_replies, url)
    stop_thread
  end

  def user_has_sweep?
    @sweepy.streak % 4 == 0
  end

  def user_has_win_streak?
    @sweepy.streak > 0 && @sweepy.losing_streak < 1
  end

  def user_has_losing_streak?
    @sweepy.streak < 1 && @sweepy.losing_streak >= 1
  end

  def user_has_no_activity?
    @sweepy.streak == 0 && @sweepy.losing_streak == 0
  end

  def current_status
    if user_has_win_streak? && user_has_sweep?
      :winning_sweep
    elsif user_has_win_streak?
      :winning_streak
    elsif user_has_losing_streak?
      :losing_streak
    elsif user_has_no_activity?
      :no_activity
    end
  end

end