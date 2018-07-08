module Commands
  CHALLENGE_OPTIONS = ["Challenges", "Challenge friends", "Challenge time?"]
  def handle_status
    @api = Api.new
    @api.fetch_user(user.id)
    show_winning_sweep_message(:message) if current_status == :winning_sweep
    show_winning_streak(:message) if current_status == :winning_streak
    show_should_use_lifeline(:message) if current_status == :should_use_lifeline
    show_should_use_lifeline_but_cant(:message) if current_status == :should_use_lifeline_but_cant
    show_losing_sweep(:message) if current_status == :losing_sweep
    show_losing_streak(:message) if current_status == :losing_streak
    show_no_activity(:message) if current_status == :no_activity
  end

  def handle_status_postback
    @api = Api.new
    @api.fetch_user(user.id)
    show_winning_sweep_message(:postback) if current_status == :winning_sweep
    show_winning_streak(:postback) if current_status == :winning_streak
    show_should_use_lifeline(:postback) if current_status == :should_use_lifeline
    show_should_use_lifeline_but_cant(:postback) if current_status == :should_use_lifeline_but_cant
    show_losing_sweep(:postback) if current_status == :losing_sweep
    show_losing_streak(:postback) if current_status == :losing_streak
    show_no_activity(:postback) if current_status == :no_activity
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

  # text = build_text_for(resource: :status, object: @api.user, options: current_status)

  def show_winning_sweep_message type
    show_my_picks(type)
    quick_replies = [{ content_type: 'text', title: "Invite friends", payload: "INVITE FRIENDS" }, { content_type: 'text', title: CHALLENGE_OPTIONS.sample, payload: "CHALLENGE" }, { content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }]
    @api.user.current_streak == 1 ? dubs = "W" : dubs = "W's"
    text = "You're on a Sweep (#{@api.user.current_streak} straight #{dubs}) 🏁"
    url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
    short_wait(type)
    show_button("Show Status", text, quick_replies, url)
    stop_thread
  end

  def show_winning_streak type
    show_my_picks(type)
    quick_replies = [{ content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: CHALLENGE_OPTIONS.sample, payload: "CHALLENGE" }]
    @api.user.current_streak == 1 ? dubs = "W" : dubs = "W's"
    options = ["You're streakin' (#{@api.user.current_streak} straight #{dubs}) 🏁", "You are lit (#{@api.user.current_streak} straight #{dubs}) 🔥", "Nom nom (#{@api.user.current_streak} straight #{dubs}) 🍔", "You're ridin' hot (#{@api.user.current_streak} straight #{dubs}) 🤠", "We have lift off (#{@api.user.current_streak} straight #{dubs}) 🚀", "You're going off (#{@api.user.current_streak} straight #{dubs}) ⏰"]
    url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
    short_wait(type)
    show_button("Show Status", options.sample, quick_replies, url)
    stop_thread
  end

  def show_should_use_lifeline type
    show_my_picks(type)
    quick_replies = [{ content_type: 'text', title: "Use lifeline", payload: "USE LIFELINE" }, { content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: CHALLENGE_OPTIONS.sample, payload: "CHALLENGE" }]
    text = "#{@api.user.current_losing_streak} straight L, but a lifeline is one tap away 👇"
    url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
    short_wait(type)
    show_button("Show Status", text, quick_replies, url)
    stop_thread
  end

  def show_should_use_lifeline_but_cant type
    show_my_picks(type)
    quick_replies = [{ content_type: 'text', title: "Invite friends", payload: "INVITE FRIENDS" }, { content_type: 'text', title: "Earn Coins", payload: "EARN COINS" }, { content_type: 'text', title: CHALLENGE_OPTIONS.sample, payload: "CHALLENGE" }]
    text = "#{@api.user.current_losing_streak} straight L. Earn more Sweepcoins to get yourself out of a jam 👇"
    url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
    short_wait(type)
    show_button("Show Status", text, quick_replies, url)
    stop_thread
  end

  def show_losing_sweep type
    show_my_picks(type)
    quick_replies = [{ content_type: 'text', title: "Invite friends", payload: "INVITE FRIENDS" }, { content_type: 'text', title: CHALLENGE_OPTIONS.sample, payload: "CHALLENGE" }, { content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }]
    @api.user.current_losing_streak == 1 ? els = "L" : els = "L's"
    options = ["Reverse streaking (#{@api.user.current_losing_streak} straight #{els}) 🔙", "Losing is the new winning (#{@api.user.current_losing_streak} straight #{els}) 🙌"]
    url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
    short_wait(type)
    show_button("Show Status", options.sample, quick_replies, url)
    stop_thread
  end

  def show_losing_streak type
    show_my_picks(type)
    quick_replies = [{ content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }, { content_type: 'text', title: CHALLENGE_OPTIONS.sample, payload: "CHALLENGE" }]
    @api.user.current_losing_streak == 1 ? els = "L" : els = "L's"
    options = ["Losing never felt so right (#{@api.user.current_losing_streak} straight #{els}) 😎", "The biggest loser (#{@api.user.current_losing_streak} straight #{els}) 👏", "All time loser (#{@api.user.current_losing_streak} straight #{els}) 🏅"]
    url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
    short_wait(type)
    show_button("Show Status", options.sample, quick_replies, url)
    stop_thread
  end

  def show_no_activity type
    show_my_picks(type)
    quick_replies = [{ content_type: 'text', title: SELECT_PICKS_OPTIONS.sample, payload: "SELECT PICKS" }]
    text = "I'm still waiting to process one of your results, so for now your streak remains at 0 ☺️"
    url = "#{ENV['WEBVIEW_URL']}/status/#{user.id}"
    short_wait(type)
    show_button("Show Status", text, quick_replies, url)
    stop_thread
  end

  def user_has_sweep?
    @api.user.current_streak % 4 == 0
  end

  def user_has_losing_sweep?
    @api.user.current_losing_streak % 4 == 0
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

  def user_has_no_activity?
    @api.user.current_streak == 0 && @api.user.current_losing_streak == 0 && @api.user.previous_streak == 0 
  end

  def user_should_use_lifeline?
    previous, current, losing_streak = @api.user.previous_streak, @api.user.current_streak, @api.user.current_losing_streak
    (previous != 1 && previous != current && previous > current && previous % 4 != 0 && previous > losing_streak)
  end

  def current_status
    if user_has_win_streak? && user_has_sweep?
      :winning_sweep
    elsif user_has_win_streak?
      :winning_streak
    elsif user_has_losing_streak? && user_should_use_lifeline? && user_can_use_lifeline?
      :should_use_lifeline
    elsif user_has_losing_streak? && user_should_use_lifeline? && !user_can_use_lifeline?
      :should_use_lifeline_but_cant
    elsif user_has_losing_streak? && user_has_losing_sweep?
      :losing_sweep
    elsif user_has_losing_streak?
      :losing_streak
    elsif user_has_no_activity?
      :no_activity
    end
  end

end