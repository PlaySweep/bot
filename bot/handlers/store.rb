def handle_show_store
  url = "#{ENV['WEBVIEW_URL']}/#{user.id}/store"
  show_button("Shop", "Spend those Sweepcoins! 🛍", nil, url)
  stop_thread 
end