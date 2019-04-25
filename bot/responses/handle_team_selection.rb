require 'haversine'

def team_select
  @sweepy = Sweep::User.find(user.id)
  if message.quick_reply
    selected_team_id = message.quick_reply.split('_')[1]
    puts "Team ID => #{selected_team_id}"
    selected_team_name = message.quick_reply.split('_')[0]
    puts "Team Name => #{selected_team_name}"
    @sweepy.update(uuid: user.id, team: selected_team_name)
    sleep 1
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

def fetch_teams coords
  available_teams = []
  coords = coords.to_dot
  say "I found your lat: #{coords.lat} and long: #{coords.long} for #{message.text}"
  teams = [{id: 17, name: "Miami Marlins", abbreviation: "Marlins", lat: 25.774269104004, long: -80.193656921387}, {id: 4, name: "Tampa Bay Rays", abbreviation: "Rays", lat: 27.947519302368, long: -82.458427429199}]
  teams.each do |team|
    distance = Haversine.distance(coords.lat, coords.long, team.lat, team.long)
      if distance.to_miles < 1000
        available_teams << team unless available_teams.size > 5
      end
  end
  text = "I found some teams! Tap below 👇"
  quick_replies = available_teams.map do |team, i|
    {
      "content_type": "text",
      "title": team[:abbreviation],
      "payload":"#{team[:name]}_#{team[:id]}",
    }
  end
  say text, quick_replies: quick_replies
  stop_thread
end

def prompt_team_select
  say "To get started, just type in your hometown or the city of the team you want to play for 👇"
  stop_thread
end