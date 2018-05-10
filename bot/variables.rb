module Commands
  def show_media(id, quick_replies)
    media = UI::MediaAttachment.new(id, quick_replies)
    show(media)
  end

  def show_button title, text, quick_replies, url=nil
    payload = [
      {
        type: :web_url,
        url: url || "#{ENV["WEBVIEW_URL"]}",
        title: title,
        webview_height_ratio: 'full',
        messenger_extensions: true
      }
    ]
    button_template = UI::FBButtonTemplate.new(text, payload, quick_replies)
    show(button_template)
  end

  def show_carousel resource, quick_replies
    show(UI::FBCarousel.new(resource, quick_replies))
  end

  def show_media_with_button user_id, endpoint, message_attachment, quick_replies
    case endpoint
    when 'dashboard'
      url = "#{ENV['WEBVIEW_URL']}/#{endpoint}/#{user_id}"
      title = "View Dashboard"
    when 'challenges'
      url = "#{ENV['WEBVIEW_URL']}/#{endpoint}/#{user_id}"
      title = "View Challenges"
    when 'status'
      url = "#{ENV['WEBVIEW_URL']}/#{endpoint}/#{user_id}"
      title = "View Status"
    end
      option = { message: {
      attachment: {
        type: "template",
        payload: {
           template_type: "media",
           elements: [
              {
                 media_type: "image",
                 attachment_id: message_attachment,
                 buttons: [
                   { type: "web_url", url: url, title: title, messenger_extensions: true }
                 ]
              }
           ]
        }
      },
      quick_replies: quick_replies
    }}

    message_options = {
      messaging_type: "RESPONSE",
      recipient: { id: user_id },
      message: option[:message]
    }

    Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
  end

  def show_invite
    titles = ["Predict the outcome of 4 games in a row and win Amazon Cash!", "Predict sports games, free. Hit a streak of 4. Win some cash."]
    subtitles = ["Add some excitement to any game (even ⚾)"]
     friends = [
       {
         title: "Friends who Sweep together win together 👯",
         image_url: "https://i.imgur.com/8F4EOpX.png",
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
                       title: titles.sample,
                       subtitle: subtitles.sample,
                       image_url: "https://i.imgur.com/8F4EOpX.png",
                       default_action: {
                         type: "web_url",
                         url: "http://www.playsweep.com?ref=#{user.id}"
                       },
                       buttons: [
                         {
                           type: "web_url",
                           messenger_extensions: true,
                           url: "https://m.me/PlaySweep?ref=#{user.id}", 
                           title: "Play Now 🎉",
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

  def show_image
    say "Wait a bit while I pick a nice random image for you"
    img_url = 'https://unsplash.it/600/400?random'
    image = UI::ImageAttachment.new(img_url)
    show(image)
  end
end
