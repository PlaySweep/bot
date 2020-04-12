def trigger_invite
  
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Status", payload: "STATUS"}]
  url = "#{ENV['WEBVIEW_URL']}/referrals/#{sweepy.slug}"
  show_button("Invite", "Share with your friends and earn prizes 🎉", quick_replies, url)
  stop_thread
  
end