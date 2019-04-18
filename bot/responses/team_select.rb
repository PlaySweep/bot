def team_select
  @sweepy = Sweep::User.find(user.id)
  if message.quick_reply
    selected_team_id = message.quick_reply.split('_')[1]
    selected_team_name = message.quick_reply.split('_')[0]
    say "Got it #{@sweepy.first_name}, from now on, you’ll see all relevant contests to the #{selected_team_name} 👍"
    say "So here's how it works: \n1. I’ll send you 3 questions for every time the #{selected_team_name} are on the field 🙌\n2. Answer 3 questions right and earn a 'Sweep' 💥\n3. A Sweep enters you into a drawing every single day to win prizes 🎟\n4. Get notified when you win and when it's time to answer more questions 🎉"
    text = "Tap below to get started 👇"
    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/dashboard/initial_load"
    show_button("Play Now ⚾️", text, nil, url)
    stop_thread
  else
    stop_thread
  end
end

def prompt_team_select
  #TODO HARD CODED TEAM IDS PLEASE REFACTOR
  text = "Please select one of the available teams below to get started 👇"
  available_teams = [{id: 1, name: "St Louis Cardinals"}, {id: 2, name: "Los Angeles Dodgers"}, {id: 11, name: "San Diego Padres"}, {id: 16, name: "Washington Nationals"}]
  quick_replies = available_teams.map do |team, i|
    {
      "content_type": "text",
      "title": team[:name],
      "payload":"#{team[:name]}_#{team[:id]}",
    }
  end
  say text, quick_replies: quick_replies
  stop_thread
end