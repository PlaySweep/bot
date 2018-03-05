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

  def show_media(id, quick_replies)
    media = UI::MediaAttachment.new(id, quick_replies)
    show(media)
  end

  def show_action_button text, quick_replies
    payload = [
      {
        type: :web_url,
        messenger_extensions: true,
        url: "#{ENV["WEBVIEW_URL"]}?id=#{user.id}",
        title: "Open Dashboard 📊",
        webview_height_ratio: 'full'
      }
    ]
    button_template = UI::FBButtonTemplate.new(text, payload, quick_replies)
    show(button_template)
  end

  def show_double_button_template text
    payload = [
      {
        type: :postback,
        payload: 'HOW TO PLAY',
        title: "How to Play 🤷"
      },
      {
        type: :web_url,
        messenger_extensions: true,
        url: "#{ENV["WEBVIEW_URL"]}?id=#{user.id}",
        title: "Make Picks 🙌",
        webview_height_ratio: 'full'
      }
    ]
    button_template = UI::FBButtonTemplate.new(text, payload)
    show(button_template)
  end

  def show_button_template sport
    payload = [
      {
        type: :web_url,
        messenger_extensions: true,
        url: "#{ENV["WEBVIEW_URL"]}?id=#{user.id}&sport=#{sport.downcase}",
        title: "Pick Now 🙌",
        webview_height_ratio: 'full'
      }
    ]
    case sport
    when 'NFL'
      quick_replies = [{ content_type: 'text', title: "NBA", payload: "NCAAB" }, { content_type: 'text', title: "Status", payload: "Status" }]
      button_template = UI::FBButtonTemplate.new("Make your picks for the NFL!", payload, quick_replies)
      show(button_template)
    when 'NCAAB'
      quick_replies = [{ content_type: 'text', title: "NFL", payload: "NFL" }, { content_type: 'text', title: "Status", payload: "Status" }]
      button_template = UI::FBButtonTemplate.new("Make your picks for the NBA!", payload, quick_replies)
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
        webview_height_ratio: 'full'
      }
    ]
    button_template = UI::FBButtonTemplate.new("Get access to our leaderboard 👍", payload)
    show(button_template)
  end

  def show_carousel
    quick_replies = [{ content_type: 'text', title: "Status", payload: "Status" }]
    show(UI::FBCarousel.new(CAROUSEL, quick_replies))
  end

  def show_invite
     get_fb_user unless @graph_user 
     friends = [
       {
         title: "Earn some Sweep coins #{@graph_user["first_name"]} 🤑",
         buttons: [
           {
             type: "element_share",
             share_contents: { 
               attachment: {
                 type: "template",
                 payload: {
                   template_type: "generic",
                   elements: [
                     {
                       title: "Predict sports games, free. Hit a streak of 4. Win some cash.",
                       subtitle: "It's real, you should say something 🤐",
                       default_action: {
                         type: "web_url",
                         url: "http://www.playsweep.com?ref=#{@graph_user["id"]}"
                       },
                       buttons: [
                         {
                           type: "web_url",
                           messenger_extensions: true,
                           url: "https://m.me/PlaySweep?ref=#{@graph_user["id"]}", 
                           title: "The Time Has Come",
                           webview_height_ratio: 'full'
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

     show(UI::FBInvite.new(friends, quick_replies = [{ content_type: 'text', title: "Status", payload: "Status" }, { content_type: 'text', title: "Select picks", payload: "Select picks" }]))
   end

  # def show_image
  #   say "Wait a bit while I pick a nice random image for you"
  #   img_url = 'https://unsplash.it/600/400?random'
  #   image = UI::ImageAttachment.new(img_url)
  #   show(image)
  # end
end
