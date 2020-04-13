def fetch_rules
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  url = "#{ENV["WEBVIEW_URL"]}/rules"
  quick_replies = [{content_type: :text, title: "Play now", image_url: sweepy.current_team.image, payload: "PLAY"}]
  show_button("Rules", "Tap below to view the official Budweiser Sweep rules 👇", quick_replies, url)
  stop_thread
end