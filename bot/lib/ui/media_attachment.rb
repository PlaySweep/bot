module UI
  # https://developers.facebook.com/docs/messenger-platform/send-api-reference/image-attachment
  class MediaAttachment
    def initialize(id, quick_replies)
      @template = {
        recipient: {
          id: nil
        },
        message: {
          attachment: {
            type: 'image',
            payload: {
              attachment_id: id
            }
          },
          quick_replies: quick_replies
        }
      }
    end

    def send(user)
      formed = build(user)
      Bot.deliver(formed, access_token: ENV['ACCESS_TOKEN'])
    end

    def build(user)
      @template[:recipient][:id] = user.id
      @template
    end
  end
end