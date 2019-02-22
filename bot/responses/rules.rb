def show_rules
  text = "You can view our official rule on our homepage below 👇"
  url = "#{ENV['WEBVIEW_URL']}/#{user.id}/dashboard"
  show_button("Rules", text, nil, url)
  stop_thread
end