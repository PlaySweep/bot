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
        webview_height_ratio: :full,
        webview_share_button: :hide,
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
           template_type: :media,
           elements: [
              {
                 media_type: :image,
                 attachment_id: attachment_id,
                 buttons: [
                   { type: :web_url, url: url, title: title, messenger_extensions: true, webview_share_button: :hide, webview_height_ratio: :full }
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
  
end
