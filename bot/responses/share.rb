def trigger_invite
  url = "#{ENV['WEBVIEW_URL']}/challenge/invite/#{sweepy.slug}"
  show_button("Invite", "Share with your friends by following the button below 👇", nil, url)
  stop_thread
end