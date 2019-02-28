def team_select
  @sweepy = Sweep::User.find(user.id)
  selected_team_id = message.quick_reply.split('_')[1]
  selected_team_name = message.quick_reply.split('_')[0]
  Sweep::Preference.update(selected_team_id, user.id)
  say "Got it #{@sweepy.first_name}, from now on, you’ll see all relevant contests to the #{selected_team_name} 👍"
  say "So here's how it works: \n1. I’ll send you 3 questions for every time the #{selected_team_name} are on the field 🙌\n2. Answer 3 questions right and earn a 'Sweep' 💥\n3. A Sweep enters you into a drawing every single day to win prizes 🎟\n4. Get notified when you win and when it's time to answer more questions 🎉"
  text = "Tap below to get started 👇"
  url = "#{ENV['WEBVIEW_URL']}/#{user.id}/dashboard/initial_load"
  show_button("Play Now ⚾️", text, nil, url)
  stop_thread
end

def prompt_team_select
  text = "For Spring training, please select one of the available teams below to get started 👇"
  available_teams = [{id: 1, name: "Cardinals"}, {id: 2, name: "Dodgers"}, {id: 3, name: "Cubs"}]
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