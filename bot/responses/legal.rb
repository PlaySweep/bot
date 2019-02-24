def legal
  text = "You can view our Rules, Terms of Use and Privacy Policy by visiting our site below 👇"
  url = "#{ENV['WEBVIEW_URL']}"
  show_button("Rules", text, nil, url)
  stop_thread
end