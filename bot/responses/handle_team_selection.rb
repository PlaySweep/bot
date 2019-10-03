def switch_prompt_message
  
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  say "If you are looking to select a team or switch, keep in mind that you will be entering contests to win prizes for whichever team you select, so you may want to take into account team proximity in case tickets are the prize 👌"
  text = "Tap below to select or switch teams 👇"
  url= "#{ENV["WEBVIEW_URL"]}/#{sweepy.id}/teams/initial_load"
  show_button("Select a team", text, nil, url)
  stop_thread
  
end