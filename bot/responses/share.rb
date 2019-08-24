def trigger_invite
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  url = "#{ENV['WEBVIEW_URL']}/invite/#{sweepy.slug}"
  show_button("Invite", "Share with your friends by tapping below 👇", nil, url)
  stop_thread
end