def handle_show_store
  quick_replies = [{ content_type: 'text', title: "Challenges", payload: "CHALLENGES" }, { content_type: 'text', title: "Status", payload: "STATUS" }, { content_type: 'text', title: "Preferences", payload: "PREFERENCES" }]
  url = "#{ENV['WEBVIEW_URL']}/#{user.id}/store"
  show_button("Store", "Load up on items 🛍", quick_replies, url)
  stop_thread 
end