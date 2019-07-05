require 'possessive'

def fetch_picks
  handle_show_sports
end

def matchups_available?
  @slates = Sweep::Slate.all(facebook_uuid: user.id)
  (@slates.nil? || @slates.empty?) ? false : true
end

def handle_show_sports
  show_carousel(elements: picks_elements)
  stop_thread
end

def picks_elements
  #TODO figure out a way to store custom team leaderboard image
  @sweepy = Sweep::User.find(facebook_uuid: user.id)
  [
      {
      title: "#{@sweepy.roles.first.abbreviation.possessive} Contests",
      image_url: @sweepy.roles.first.team_entry_image,
      subtitle: "Make selections for your #{@sweepy.roles.first.team_name} every week and win awesome prizes!",
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
        title: "#{@sweepy.roles.first.abbreviation} Leaderboard",
        image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/bud_light_leaderboard_logo2.png",
        subtitle: "See how you rank against the competition!",
        buttons: [
          {
            type: :web_url,
            url: "#{ENV["WEBVIEW_URL"]}/#{@sweepy.facebook_uuid}/dashboard/initial_load?tab=2",
            title: "Leaderboard",
            webview_height_ratio: 'full',
            messenger_extensions: true
          }
        ]
      }
  ]
end