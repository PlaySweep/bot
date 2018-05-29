module Commands
  def handle_feedback
    qr = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
    show_button("Show Challenges", "Sorry, I was too focused on sending feedback 🙈\n\nTap below to respond to any pending challenges 👇", qr, "#{ENV['WEBVIEW_URL']}/challenges/#{user.id}") and stop_thread and return if (message.quick_reply.split(' ')[1] == 'CHALLENGE')
    @api = Api.new
    @api.fetch_user(user.id)
    full_name = @api.user.full_name
    short_wait(:message)
    feedback = message.text
    [1566539433429514].each do |facebook_uuid|
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
    say "Thank you 😇"
    short_wait(:message)
    #TODO more options
    options = ["I'm already feeling more self aware 🤓", "That wasn't so hard 😌"]
    say options.sample, quick_replies: ['Select picks', 'Status']
    stop_thread
  end
end