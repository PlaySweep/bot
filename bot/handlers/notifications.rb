module Commands
  def handle_show_preferences
    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/preferences"
    show_button("Manage preferences", "Customize your alerts below 🔔", nil, url)
    stop_thread  
  end

  def handle_unsubscribe
    @sweepy = Sweep::User.find(user.id)
    @sweepy.unsubscribe
    say "I unsubscribed you from any further messages 🔕.", quick_replies: ["Select picks"]
    stop_thread
  end
end