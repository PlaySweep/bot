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

  def show_invite
    @sweepy = Sweep::User.find(facebook_uuid: user.id)
    titles = ["Play The Budweiser Sweep and earn incredible #{@sweepy.roles.first.team_name} prizes ⚾️"]
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
                           url: "https://m.me/606217113124396?ref=#{@sweepy.roles.first.team_name.split(' ').map(&:downcase).join('_')}?referrer_uuid=#{user.id}", 
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
