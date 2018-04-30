module Commands
  def handle_my_picks
    @api = Api.new
    @api.fetch_user(user.id)
    say "Next up is ..."
    short_wait(:message)
    show_media_with_button(user.id, 'dashboard', DASHBOARD_IMAGE)
    stop_thread
  end

  def handle_my_picks_for_postback
    @api = Api.new
    @api.fetch_user(user.id)
    say "Next up is ..."
    short_wait(:postback)
    show_media_with_button(user.id, 'dashboard', DASHBOARD_IMAGE)
    stop_thread
  end
end