module UI
  ########################### BUTTON TEMPLATE #############################
  # https://developers.facebook.com/docs/messenger-platform/send-api-reference/button-template
  class FBButtonTemplate
    def initialize(text, buttons, image_url = nil, quick_replies = nil)
      @template = {
        recipient: {
          id: nil
        },
        message: {
          attachment: {
            type: 'template',
            payload: {
              template_type: 'button',
              text: text,
              image_url: image_url,
              buttons: parse_buttons(buttons)
            }
          }
        }
      }
      if quick_replies && quick_replies.any?
        @template[:message][:quick_replies] = quick_replies
      end
    end

    # Sends the valid JSON to Messenger API
    def send(user)
      formed = build(user)
      Bot.deliver(formed, access_token: ENV['ACCESS_TOKEN'])
    end

    # Use this method to return a valid hash and save it for later
    def build(user)
      @template[:recipient][:id] = user.id
      @template
    end

    private

    def parse_buttons(buttons)
      return [] if buttons.nil? || buttons.empty?
      buttons.map do |button|
        button[:type] = button[:type].to_s
        button
      end
    end
  end
end