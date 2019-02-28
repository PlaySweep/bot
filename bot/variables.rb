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

  def show_carousel resource, quick_replies
    show(UI::FBCarousel.new(resource, quick_replies))
  end

  def show_media_with_button user_id, endpoint, message_attachment, quick_replies
    case endpoint
    when 'challenges'
      url = "#{ENV['WEBVIEW_URL']}/#{endpoint}/#{user_id}"
      title = "My Challenges"
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
                   { type: "web_url", url: url, title: title, messenger_extensions: true, webview_height_ratio: 'full' }
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
    @sweepy = Sweep::User.find(user.id)
    titles = ["Play The Budweiser Sweep and earn incredible Cardinals prizes ⚾️"]
    subtitles = ["Answer 3 questions for each game, get them all right, and you could win your way to primetime seats 🎉"]
     friends = [
       {
         title: "Invite your friends to play the Budweiser Sweep! 😎",
         image_url: "https://www.underconsideration.com/brandnew/archives/budweiser_2016_logo_detail.png",
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
                       image_url: "https://www.underconsideration.com/brandnew/archives/budweiser_2016_logo_detail.png",
                       buttons: [
                         {
                           type: "web_url",
                           messenger_extensions: true,
                           url: "https://m.me/606217113124396?ref=#{user.id}_#{1}", 
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

     show(UI::FBInvite.new(friends))
   end

  def show_image
    say "Wait a bit while I pick a nice random image for you"
    img_url = 'https://unsplash.it/600/400?random'
    image = UI::ImageAttachment.new(img_url)
    show(image)
  end
end
