def switch_prompt_message
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{ content_type: :text, title: "Talk to human", payload: "HUMAN" }, { content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY" }, { content_type: :text, title: "Share", payload: "SHARE" }]
  text = "If you need customer support, please select Talk to human below..."
  say text, quick_replies: quick_replies
  stop_thread
end