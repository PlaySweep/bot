def switch_prompt_message
  examples = ["Dodgers or Baltimore Orioles", "Cardinals or New York Mets", "Diamondbacks or Miami Marlins"]
  say "If you are looking to select a team or switch, keep in mind that you will be entering contests to win prizes for whichever team you select, so you may want to take into account team proximity in case tickets are the prize 👌"
  text = "Tap below to select or switch teams 👇"
  url= "#{ENV["WEBVIEW_URL"]}/#{user.id}/teams/initial_load"
  show_button("Select a team", text, nil, url)
end