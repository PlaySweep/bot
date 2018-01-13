desc "Test Reminder"
task :test_reminder do
  
  menu = [
    {
      content_type: 'text',
      title: 'Use mulligan',
      payload: 'Use mulligan'
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
    recipient: { id: 1594944847261256 },
    message: {
      text: "The Falcons came up short against the spread (+3.5) with a 21-27 loss to the Eagles.\n\nBut fortunately, you have a mulligan to use to keep your streak alive!",
      quick_replies: menu
    }
  }
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
end

desc "Test Recap"
task :test_recap do

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
    recipient: { id: 1594944847261256 },
    message: {
      text: "Nice 24-20 cover with the Eagles Ryan 🦅! You've got 1 win in a row 🔥\n\nDon't miss this chance to earn an extra game by getting one of your friends to play on Sweep with you!",
      quick_replies: menu
    }
  }
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
end