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
    say "So here's how it works: \n1. I’ll send you 3 questions for every time the #{selected_team_name} are on the field 🙌\n2. Answer 3 questions right and earn a 'Sweep' 💥\n3. A Sweep enters you into a drawing every single day to win prizes 🎟\n4. Get notified when you win and when it's time to answer more questions 🎉"
    show_carousel(elements: team_select_elements)
    stop_thread
  else
    if @sweepy.roles.first.nil?
      say "Type switch if you want to select or change teams."
      stop_thread
    else
      stop_thread
    end
  end
end

def team_select_elements
  #TODO change image to fb lockup version
  @sweepy = Sweep::User.find(facebook_uuid: user.id)
  contest_copy = sweepy.copies.find { |copy| copy.category == "Contest Subtitle" }
  interpolated_contest_copy = contest_copy % { team_abbreviation: @sweepy.roles.first.team_name }
  [
      {
      title: "#{@sweepy.roles.first.abbreviation} Contests",
      image_url: @sweepy.roles.first.team_entry_image,
      subtitle: interpolated_contest_copy,
      buttons: [
        {
          type: :web_url,
          url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{@sweepy.slug}/1",
          title: "Play now",
          webview_height_ratio: 'full',
          messenger_extensions: true
        }
      ]
    },
    {
      title: "Status",
      image_url: @sweepy.images.find { |image| image.category == "Status" }.url,
      subtitle: "Check your results or make any changes before the games start!",
      buttons: [
        {
          type: :web_url,
          url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{@sweepy.slug}/2",
          title: "Status",
          webview_height_ratio: 'full',
          messenger_extensions: true
        }
      ]
    }
  ]
end