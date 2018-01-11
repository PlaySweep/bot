desc "Test Reminder"
task :test_reminder do
  # if [:PROD_USER]
  #   user = 1827403637334265
  # else
  #   user = 1842184635853672
  # end

  menu = [
    {
      content_type: 'text',
      title: 'Select picks',
      payload: 'Select picks'
    },
    {
      content_type: 'text',
      title: 'Status',
      payload: 'Status'
    },
    {
      content_type: 'text',
      title: 'Manage updates',
      payload: 'Manage updates'
    }
  ]

  message_options = {
    messaging_type: "UPDATE",
    recipient: { id: 1842184635853672 },
    message: {
      text: "Hey Ryan 👋, we noticed you don't have any upcoming picks for the day, but that's ok! You've still got time...\n\nGet in there and make your picks below 👇",
      quick_replies: menu
    }
  }
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
end

desc "Test Recap"
task :test_recap do
  # if [:PROD_USER]
  #   user = 1827403637334265 # sweep
  # else
  #   user = 1842184635853672 # sweep_development
  # end

  menu = [
    {
      content_type: 'text',
      title: 'Earn another game',
      payload: 'Invite friends'
    },
    {
      content_type: 'text',
      title: 'Status',
      payload: 'Status'
    },
    {
      content_type: 'text',
      title: 'Manage updates',
      payload: 'Manage updates'
    }
  ]

  message_options = {
    messaging_type: "UPDATE",
    recipient: { id: 1842184635853672 },
    message: {
      text: "Nice 24-20 cover with the Eagles Ryan 🦅! You've got 1 win in a row 🔥\n\nDon't miss this chance to earn an extra game by getting one of your friends to play on Sweep with you!",
      quick_replies: menu
    }
  }
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
end