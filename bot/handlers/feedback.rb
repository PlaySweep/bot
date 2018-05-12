require 'popcorn'

module Commands
  def handle_feedback
    @api = Api.new
    @api.fetch_user(user.id)
    full_name = @api.user.full_name
    short_wait(:message)
    feedback = message.text
    [1594944847261256].each do |facebook_uuid|
      message_options = {
        messaging_type: "UPDATE",
        recipient: { id: facebook_uuid },
        message: {
          text: "Feedback from #{full_name},\n\n#{feedback}",
        }
      }
      Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
    end
    #TODO test popcorn
    # Popcorn.notify(['4805227771', '6025103385'], "Emma captured some feedback from #{full_name},\n\n#{feedback}")
    #TODO more options
    say "Thank you 😇"
    short_wait(:message)
    options = ["I'm already feeling more self aware 🤓"]
    say options.sample, quick_replies: ['Select picks', 'Status']
    stop_thread
  end
end