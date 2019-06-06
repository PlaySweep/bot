def show_prizes
  @sweepy = Sweep::User.find(facebook_uuid: user.id)
  say "Prizes change every single day for the #{@sweepy.roles.first.abbreviation} depending on the contest, but the prizes that are available are primarily game tickets and merchandise ⚾️"
  show_carousel(elements: prizing_elements)
  stop_thread
end

def prizing_elements
  [
        {
        title: "All-Star Contest Prizing",
        image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/allstar_prizing_logo.png",
        subtitle: "There are tons of prizes on the line for the All-Star Contest!",
        buttons: [
          {
            type: :web_url,
            url: "#{ENV["WEBVIEW_URL"]}/prizing/allstar",
            title: "Prizes",
            webview_height_ratio: 'full',
            messenger_extensions: true
          }
        ]
      }
  ]
end