def team_select
  @sweepy = Sweep::User.find(facebook_uuid: user.id)
  if message.quick_reply
    selected_team_id = message.quick_reply.split('_')[1]
    puts "Team ID => #{selected_team_id}"
    selected_team_name = message.quick_reply.split('_')[0]
    puts "Team Name => #{selected_team_name}"
    @sweepy.update(uuid: user.id, team: selected_team_name)
    sleep 1
    say "Got it #{@sweepy.first_name}! From now on, you’ll see all relevant contests to the #{selected_team_name} 👍"
    say "So here's how it works: \n1. I’ll send you 6 questions for every time the #{selected_team_name} are on the field 🙌\n2. Answer 6 questions right and earn a 'Sweep' 💥\n3. A Sweep enters you into a drawing every single day to win prizes 🎟\n4. Get notified when you win and when it's time to answer more questions 🎉"
    show_carousel(elements: team_select_elements)
    stop_thread
  else
    stop_thread
  end
end

def prompt_team_select
  #TODO HARD CODED TEAM IDS PLEASE REFACTOR
  text = "Please select one of the available teams below to get started 👇"
  available_teams = [{id: 18, name: "Minnesota Twins", abbreviation: "Twins"}, {id: 14, name: "Houston Astros", abbreviation: "Astros"}, {id: 7, name: "Arizona Diamondbacks", abbreviation: "Diamondbacks"}, {id: 8, name: "Chicago White Sox", abbreviation: "White Sox"}, {id: 9, name: "Baltimore Orioles", abbreviation: "Orioles"}, {id: 13, name: "New York Yankees", abbreviation: "Yankees"}]
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

def team_select_elements
  #TODO change image to fb lockup version
  @sweepy = Sweep::User.find(facebook_uuid: user.id)
  [
      {
      title: "#{@sweepy.roles.first.abbreviation} Contests",
      image_url: @sweepy.roles.first.local_image,
      subtitle: "Make selections for your #{@sweepy.roles.first.team_name} every day and win awesome prizes!",
      buttons: [
        {
          type: :web_url,
          url: "#{ENV["WEBVIEW_URL"]}/#{@sweepy.facebook_uuid}/dashboard/initial_load?tab=1",
          title: "Play now",
          webview_height_ratio: 'full',
          messenger_extensions: true
        }
      ]
    },
      {
      title: "Road to All-Star",
      image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/allstar_prizing_image.png",
      subtitle: "Play the Road to All-Star for a chance to win tickets to the game and more!",
      buttons: [
        {
          type: :web_url,
          url: "#{ENV["WEBVIEW_URL"]}/#{@sweepy.facebook_uuid}/dashboard/initial_load?tab=2",
          title: "Play now",
          webview_height_ratio: 'full',
          messenger_extensions: true
        }
      ]
    }
  ]
end