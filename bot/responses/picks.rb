def fetch_picks
  if matchups_available?
    handle_show_sports
  else
    handle_no_sports_available
  end
end

def matchups_available?
  @slates = Sweep::Slate.all(facebook_uuid: user.id)
  (@slates.nil? || @slates.empty?) ? false : true
end

def handle_show_sports
  show_carousel(elements: picks_elements)
  stop_thread
end

def handle_no_sports_available
  options = [
    "You're all caught up across the board. I'll have more games soon."
  ]

  url = "#{ENV['WEBVIEW_URL']}/#{user.id}/dashboard/initial_load?tab=3" 
  stop_thread
end

def picks_elements
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