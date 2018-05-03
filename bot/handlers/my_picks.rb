module Commands
  def handle_my_picks
    @api = Api.new
    @api.fetch_user(user.id)
    say "Next up is ..."
    short_wait(:message)
    quick_replies = [{ content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge friends", payload: "CHALLENGE A FRIEND" }]
    show_media_with_button(user.id, 'dashboard', DASHBOARD_IMAGE, quick_replies)
    stop_thread
  end

  def handle_my_picks_for_postback
    @api = Api.new
    @api.fetch_user(user.id)
    say "Next up is ..."
    short_wait(:postback)
    quick_replies = [{ content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge friends", payload: "CHALLENGE A FRIEND" }]
    show_media_with_button(user.id, 'dashboard', DASHBOARD_IMAGE, quick_replies)
    stop_thread
  end
end