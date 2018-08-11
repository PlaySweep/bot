def send_confirmation referrer_id, referred_id
  new_user = Sweep::User.find(referred_id)

  menu = [
    {
      content_type: 'text',
      title: 'Share 🎉',
      payload: 'INVITE FRIENDS'
    },
    {
      content_type: 'text',
      title: 'Make picks',
      payload: 'SELECT PICKS'
    }
  ]
  message_options = {
    messaging_type: "UPDATE",
    recipient: { id: referrer_id },
    message: {
      text: "#{new_user['first_name']} #{new_user['last_name']} joined!\n\n100 Sweepcoins have been added to your wallet 💰",
      quick_replies: menu
    }
  }
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
end