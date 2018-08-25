module Commands
  def handle_show_preferences
    quick_replies = [{ content_type: 'text', title: "Challenges", payload: "CHALLENGES" }, { content_type: 'text', title: "Status", payload: "STATUS" }, { content_type: 'text', title: "Preferences", payload: "PREFERENCES" }]
    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/preferences"
    show_button("Manage preferences", "Customize your alerts below 🔔", quick_replies, url)
    stop_thread  
  end

  def handle_unsubscribe
    @sweepy = Sweep::User.find(user.id)
    @sweepy.unsubscribe
    say "I unsubscribed you from any further messages 🔕.", quick_replies: ["Preferences", "Make picks"]
    stop_thread
  end
end