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
    contest_copy = @sweepy.copies.find { |copy| copy.category == "Contest Subtitle" }.sample.message
    interpolated_contest_copy = contest_copy % { team_abbreviation: @sweepy.roles.first.abbreviation }
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
  else
    [
        {
        title: "#{@sweepy.account.friendly_name.capitalize} Game of the Day",
        image_url: @sweepy.images.find { |image| image.category == "Account Lockup" }.url,
        subtitle: "Make selections for the #{@sweepy.account.friendly_name.capitalize} Game of the Day and win awesome prizes!",
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
end