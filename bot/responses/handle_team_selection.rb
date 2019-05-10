require 'haversine'

def switch_prompt
  @sweepy = Sweep::User.find(user.id)
  selected_team_name = message.text.gsub(/[^0-9A-Za-z]/, ' ')
  @teams = Sweep::Team.by_name(name: selected_team_name)
  if @teams.any?
    say "Would you like to switch from the #{@sweepy.roles.first.team_name} to the #{selected_team_name}?", quick_replies: ["Yes", "No"]
    user.session[:selected_team_name] = selected_team_name
    next_command :team_select_change
  else
    say "Sorry, we currently don't offer Budweiser Sweep contests for that team.\n\nYou can try another team, i.e. Texas Rangers or Dodgers"
    stop_thread
  end
end

def team_select_change
  @sweepy = Sweep::User.find(user.id)
  case message.quick_reply
  when "YES"
    @teams = Sweep::Team.by_name(name: user.session[:selected_team_name])
    if @teams.any?
      @sweepy.update(uuid: user.id, team: user.session[:selected_team_name])
      say "Got it #{@sweepy.first_name}, from now on, you’ll see all relevant contests to the #{@teams.first.abbreviation} 👍"
      say "So here's how it works: \n1. I’ll send you 3 questions for every time the #{@teams.first.abbreviation} are on the field 🙌\n2. Answer 3 questions right and earn a 'Sweep' 💥\n3. A Sweep enters you into a drawing every single day to win prizes 🎟\n4. Get notified when you win and when it's time to answer more questions 🎉"
      text = "Tap below to get started 👇"
      url = "#{ENV['WEBVIEW_URL']}/#{user.id}/dashboard/initial_load"
      show_button("Play Now ⚾️", text, nil, url)
      clear_session
      stop_thread
    else
      say "Sorry, we currently don't offer Budweiser Sweep contests for that team. Remember to either type the name or abbreviation of the team, i.e. Los Angeles Dodgers or Dodgers"
      clear_session
      stop_thread
    end
  when "NO"
    say "Ok 👌"
    text = "#{@sweepy.roles.first.team_name} games below 👇"
    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/dashboard/initial_load"
    show_button("Play Now ⚾️", text, nil, url)
    clear_session
    stop_thread
  else
    say "Sorry, I didn't catch that."
    stop_thread
  end
end

def team_select
  @sweepy = Sweep::User.find(user.id)
  if message.quick_reply
    selected_team_name = message.quick_reply.split('_')[0]
    @sweepy.update(uuid: user.id, team: selected_team_name)
    say "Got it #{@sweepy.first_name}, from now on, you’ll see all relevant contests to the #{selected_team_name} 👍"
    say "So here's how it works: \n1. I’ll send you 3 questions for every time the #{selected_team_name} are on the field 🙌\n2. Answer 3 questions right and earn a 'Sweep' 💥\n3. A Sweep enters you into a drawing every single day to win prizes 🎟\n4. Get notified when you win and when it's time to answer more questions 🎉"
    text = "Tap below to get started 👇"
    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/dashboard/initial_load"
    show_button("Play Now ⚾️", text, nil, url)
    stop_thread
  else
    selected_team_name = message.text.gsub(/[^0-9A-Za-z]/, ' ')
    @teams = Sweep::Team.by_name(name: selected_team_name)
    if @teams.any?
      @sweepy.update(uuid: user.id, team: selected_team_name)
      say "Got it #{@sweepy.first_name}, from now on, you’ll see all relevant contests to the #{@teams.first.abbreviation} 👍"
      say "So here's how it works: \n1. I’ll send you 3 questions for every time the #{@teams.first.abbreviation} are on the field 🙌\n2. Answer 3 questions right and earn a 'Sweep' 💥\n3. A Sweep enters you into a drawing every single day to win prizes 🎟\n4. Get notified when you win and when it's time to answer more questions 🎉"
      text = "Tap below to get started 👇"
      url = "#{ENV['WEBVIEW_URL']}/#{user.id}/dashboard/initial_load"
      show_button("Play Now ⚾️", text, nil, url)
      stop_thread
    else
      say "Sorry, we currently don't offer Budweiser Sweep contests for that team. Remember to either type the name or abbreviation of the team, i.e. Los Angeles Dodgers or Dodgers"
      stop_thread
    end
  end
end

def fetch_teams coords
  available_teams = []
  teams = Sweep::Team.all
  radius = 250
  while available_teams.size < 3
    teams.each do |team|
      distance = Haversine.distance(coords.lat, coords.long, team.lat.to_f, team.long.to_f).to_miles
      if distance < radius
        available_teams << team unless available_teams.include?(team) || available_teams.size > 3
      end
    end
    radius *= 3
  end
  text = "I found some teams near #{message.text}! Tap below 👇"
  quick_replies = available_teams.map do |team|
    {
      "content_type": "text",
      "title": team.abbreviation,
      "payload":"#{team.name}_#{team.id}",
    }
  end
  text = "I found some teams near #{message.text}!\n\nBut if you don't see the team you want - we have more 👇"
  url = "#{ENV['WEBVIEW_URL']}/#{user.id}/dashboard/initial_load"
  show_button("Select team ⚾️", text, quick_replies, url)
  stop_thread
end

def prompt_team_select
  say "Give us a nearby city and I'll do a quick search to find what teams are available for you 👇"
  stop_thread
end

def clear_session
  user.session[:selected_team_name] = ""
end