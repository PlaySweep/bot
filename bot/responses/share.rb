def trigger_invite
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Status", payload: "STATUS"}]
  url = "#{ENV['WEBVIEW_URL']}/invite/#{sweepy.slug}"
  show_button("Invite", "Share with your friends by tapping below 👇", quick_replies, url)
  stop_thread
  message.typing_off
end