module Commands
  def show_media(id, quick_replies)
    media = UI::MediaAttachment.new(id, quick_replies)
    show(media)
  end

  def show_button title, text, quick_replies=nil, url=nil
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

  def show_carousel elements:, quick_replies: nil
    if quick_replies
      show(UI::FBCarousel.new(elements, quick_replies))
    else
      show(UI::FBCarousel.new(elements))
    end
  end

  def show_media_with_button user_id, title, attachment_id, url, quick_replies=nil
      option = { message: {
      attachment: {
        type: "template",
        payload: {
           template_type: "media",
           elements: [
              {
                 media_type: "image",
                 attachment_id: attachment_id,
                 buttons: [
                   { type: "web_url", url: url, title: title, messenger_extensions: true, webview_height_ratio: 'full' }
                 ]
              }
           ]
        }
      }
    }}

    if quick_replies && quick_replies.any?
      option[:message][:quick_replies] = quick_replies
    end

    message_options = {
      messaging_type: "UPDATE",
      recipient: { id: user_id },
      message: option[:message]
    }

    Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
  end

  def show_image
    say "Wait a bit while I pick a nice random image for you"
    img_url = 'https://unsplash.it/600/400?random'
    image = UI::ImageAttachment.new(img_url)
    show(image)
  end

  def show_invite
      sweepy = Sweep::User.find(facebook_uuid: user.id)
      titles = ["Play The #{sweepy.account.app_name} and win incredible prizes"]
       friends = [
         {
           title: "Invite your friends to play the Budweiser Sweep!",
           image_url: sweepy.images.find { |image| image.category == "Status" }.url,
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
                         image_url: sweepy.images.find { |image| image.category == "Status" }.url,
                         buttons: [
                           {
                             type: "web_url",
                             messenger_extensions: true,
                             url: sweepy.links.find { |link| link.category == "Facebook Page" }.url, 
                             title: "Play Now",
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

       show(UI::FBInvite.new(friends))
     end
end
