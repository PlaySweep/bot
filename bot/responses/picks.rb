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
  #TODO change image to fb lockup version
  @sweepy = Sweep::User.find(facebook_uuid: user.id)
  if @sweepy.roles.first
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
        title: "Status",
        image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/fb_status_logo2.png",
        subtitle: "Check your results or make any changes before the games start!",
        buttons: [
          {
            type: :web_url,
            url: "#{ENV["WEBVIEW_URL"]}/#{@sweepy.facebook_uuid}/dashboard/initial_load?tab=3",
            title: "Status",
            webview_height_ratio: 'full',
            messenger_extensions: true
          }
        ]
      }
    ]
  else
    [
        {
        title: "Budweiser Game of the Day",
        image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/budweiser_mlb_fb_lockup.png",
        subtitle: "Make selections for the Budweiser Game of the Day and win awesome prizes!",
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
        title: "Status",
        image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/fb_status_logo2.png",
        subtitle: "Check your results or make any changes before the games start!",
        buttons: [
          {
            type: :web_url,
            url: "#{ENV["WEBVIEW_URL"]}/#{@sweepy.facebook_uuid}/dashboard/initial_load?tab=3",
            title: "Status",
            webview_height_ratio: 'full',
            messenger_extensions: true
          }
        ]
      }
    ]
  end
end