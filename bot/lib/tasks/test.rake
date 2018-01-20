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
    recipient: { id: 1328837993906209 },
    message: {
      text: "The Falcons came up short against the spread (+3.5) with a 21-27 loss to the Eagles.\n\nBut fortunately, you have a mulligan to use to keep your streak alive!",
      quick_replies: menu
    }
  }
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
  sleep 1
  reminder_gifs = [{id: 1517926024923101, title: "Jennifer Lawrence Thumbs Up"}]
  media_options = {
    messaging_type: "UPDATE",
    recipient: { id: 1328837993906209 },
    message: {
      attachment: {
        type: 'image',
        payload: {
          attachment_id: reminder_gifs.sample[:id]
        }
      },
      quick_replies: menu
    }
  }
  Bot.deliver(media_options, access_token: ENV['ACCESS_TOKEN'])
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
    recipient: { id: 1328837993906209 },
    message: {
      text: "Nice 24-20 cover with the Eagles Ryan 🦅!\nYou've got 1 win in a row 🔥",
      quick_replies: menu
    }
  }
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
  sleep 1
  win_gifs = [{id: 1517896908259346, title: "Keanu Reeves Thumbs Up"}, {id: 1517900044925699, title: "Sean Connery Fist Pump"}, {id: 1517919341590436, title: "Nicolas Cage Con Air"}, {id: 1517920478256989, title: "Beard Man Happy Approval"}, {id: 1517922411590129, title: "Black Guy On Pier Dusting Hands Off"}]
  media_options = {
    messaging_type: "UPDATE",
    recipient: { id: 1328837993906209 },
    message: {
      attachment: {
        type: 'image',
        payload: {
          attachment_id: win_gifs.sample[:id]
        }
      },
      quick_replies: menu
    }
  }
  Bot.deliver(media_options, access_token: ENV['ACCESS_TOKEN'])
  sleep 1
  loss_gifs = [{id: 1517902454925458, title: "Ryan Gosling Face Palm"}, {id: 1517903024925401, title: "Harry Potter Eye Roll"}, {id: 1517906254925078, title: "Michael Scott Im Fine/No Im not"}]
  media_options = {
    messaging_type: "UPDATE",
    recipient: { id: 1328837993906209 },
    message: {
      attachment: {
        type: 'image',
        payload: {
          attachment_id: loss_gifs.sample[:id]
        }
      },
      quick_replies: menu
    }
  }
  Bot.deliver(media_options, access_token: ENV['ACCESS_TOKEN'])
end