module Commands
  # Format of hashes follows JSON format from Messenger Platform documentation:
  # https://developers.facebook.com/docs/messenger-platform/send-messages/templates
  CAROUSEL = [
    {
      title: 'Random image',
      # Horizontal image should have 1.91:1 ratio
      image_url: 'https://unsplash.it/760/400?random',
      subtitle: "That's a first card in a carousel",
      default_action: {
        type: 'web_url',
        url: 'https://unsplash.it'
      },
      buttons: [
        {
          type: :web_url,
          url: 'https://unsplash.it',
          title: 'Website'
        }
      ]
    },
    {
      title: 'Another random image',
      # Horizontal image should have 1.91:1 ratio
      image_url: 'https://unsplash.it/600/315?random',
      subtitle: "And here's a second card. You can add up to 10!",
      default_action: {
        type: 'web_url',
        url: 'https://unsplash.it'
      },
      buttons: [
        {
          type: :web_url,
          url: 'https://unsplash.it',
          title: 'Website'
        }
      ]
    }
  ].freeze

  def show_button_template sport
    payload = [
      {
        type: :web_url,
        messenger_extensions: true,
        url: "#{ENV["WEBVIEW_URL"]}?id=#{user.id}&sport=#{sport.downcase}",
        title: "Pick now 🙌",
        webview_height_ratio: 'tall'
      }
    ]
    case sport
    when 'NFL'
      quick_replies = [{ content_type: 'text', title: "NCAA", payload: "NCAA" }, { content_type: 'text', title: "NBA", payload: "NBA" }]
      button_template = UI::FBButtonTemplate.new("Are you ready to make your picks for the NFL?", payload, quick_replies)
      show(button_template)
    when 'NCAA'
      quick_replies = [{ content_type: 'text', title: "NFL", payload: "NFL" }, { content_type: 'text', title: "NBA", payload: "NBA" }]
      button_template = UI::FBButtonTemplate.new("Are you ready to make your picks for the NCAA?", payload, quick_replies)
      show(button_template)
    when 'NBA'
      quick_replies = [{ content_type: 'text', title: "NFL", payload: "NFL" }, { content_type: 'text', title: "NCAA", payload: "NCAA" }]
      button_template = UI::FBButtonTemplate.new("Are you ready to make your picks for the NBA?", payload, quick_replies)
      show(button_template)
    end
  end

  def show_login
    payload = [
      {
        type: :web_url,
        messenger_extensions: true,
        url: "#{ENV["BOT_URL"]}/request",
        title: "Log in with Facebook",
        webview_height_ratio: 'tall'
      }
    ]
    button_template = UI::FBButtonTemplate.new("Get access to our leaderboard 👍", payload)
    show(button_template)
  end

  def show_carousel
    show(UI::FBCarousel.new(CAROUSEL))
  end

  def show_image
    say "Wait a bit while I pick a nice random image for you"
    img_url = 'https://unsplash.it/600/400?random'
    image = UI::ImageAttachment.new(img_url)
    show(image)
  end
end
