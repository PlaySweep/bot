module Commands
  def handle_feedback
    #TODO clean up copy
    @api = Api.new
    @api.fetch_user(user.id)
    full_name = @api.user.full_name
    short_wait(:message)
    feedback = message.text
    [1842184635853672].each do |facebook_uuid|
      message_options = {
        messaging_type: "UPDATE",
        recipient: { id: facebook_uuid },
        message: {
          text: "Feedback from #{full_name},\n\n#{feedback}",
        }
      }
      Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
    end
    say "I am becoming more and more self aware...🤓", quick_replies: ['Select picks', 'Status']
    stop_thread
  end
end