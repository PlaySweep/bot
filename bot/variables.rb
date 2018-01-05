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

  INVITE_FRIENDS = [
    {
      "title":"Once they accept your invite and play, you'll get a mulligan. They will too!",
      "subtitle":"Use mulligans if you lose to keep your winning streak alive!",
      "image_url":"https://i.imgur.com/kDb3LQo.png",
      "buttons": [
        {
          "type": "element_share",
          "share_contents": { 
            "attachment": {
              "type": "template",
              "payload": {
                "template_type": "generic",
                "elements": [
                  {
                    "title": "Sweep",
                    "subtitle": "Hit 4 Consecutive Wins and earn Amazon Cash!",
                    "default_action": {
                      "type": "web_url",
                      "url": "http://www.playsweep.com/"
                    },
                    "buttons": [
                      {
                        "type": "web_url",
                        "url": "http://m.me/PlaySweep", 
                        "title": "Try Out Sweep"
                      }
                    ]
                  }
                ]
              }
            }
          }
        }
      ]
    }
  ].freeze

  def show_button_template sport
    case sport
    when 'NFL'
      image_url = "https://i.imgur.com/ke2hFzp.png"
    when 'NCAAF'
      image_url = "https://i.imgur.com/mveSwHJ.png"
    end
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
      quick_replies = [{ content_type: 'text', title: "NCAAF", payload: "NCAAF" }]
      button_template = UI::FBButtonTemplate.new("Are you ready to make your picks for the NFL?", payload, image_url, quick_replies)
      show(button_template)
    when 'NCAAF'
      quick_replies = [{ content_type: 'text', title: "NFL", payload: "NFL" }]
      button_template = UI::FBButtonTemplate.new("Are you ready to make your picks for the NCAAF?", payload, image_url, quick_replies)
      show(button_template)
    # when 'NBA'
    #   quick_replies = [{ content_type: 'text', title: "NFL", payload: "NFL" }, { content_type: 'text', title: "NCAAF", payload: "NCAAF" }]
    #   button_template = UI::FBButtonTemplate.new("Are you ready to make your picks for the NBA?", payload, quick_replies)
    #   show(button_template)
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

  def show_invite
    show(UI::FBInvite.new(INVITE_FRIENDS, quick_replies = [{ content_type: 'text', title: "Status", payload: "STATUS" }, { content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }]))
  end

  # def show_image
  #   say "Wait a bit while I pick a nice random image for you"
  #   img_url = 'https://unsplash.it/600/400?random'
  #   image = UI::ImageAttachment.new(img_url)
  #   show(image)
  # end
end
