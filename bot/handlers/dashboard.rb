module Commands
  def handle_dashboard
    quick_replies = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge friends", payload: "CHALLENGES" }]
    short_wait(:message)
    show_media_with_button(user.id, 'dashboard', DASHBOARD_IMAGE, quick_replies)
    stop_thread
  end

  def handle_dashboard_postback
    quick_replies = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "My picks", payload: "MY PICKS" }, { content_type: 'text', title: "Challenge friends", payload: "CHALLENGES" }]
    short_wait(:postback)
    show_media_with_button(user.id, 'dashboard', DASHBOARD_IMAGE, quick_replies)
    stop_thread
  end
end