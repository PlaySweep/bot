def switch_prompt_message
  
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{ content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY" }, { content_type: :text, title: "Share", payload: "SHARE" }]
  text = "Tap below to select or switch teams 👇"
  url= "#{ENV["WEBVIEW_URL"]}/#{sweepy.id}/teams/initial_load"
  show_button("View teams", text, quick_replies, url)
  stop_thread
  
end