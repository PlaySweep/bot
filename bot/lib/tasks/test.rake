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
  reminder_gifs = [{id: 1517413058307731, title: "Jennifer Lawrence Thumbs Up"}]
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
  win_gifs = [{id: 1186125711517480, title: "Keanu Reeves Thumbs Up"}, {id: 1186125928184125, title: "Sean Connery Fist Pump"}]
  media_options = {
    messaging_type: "UPDATE",
    recipient: { 1328837993906209 },
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

  # loss_gifs = [{id: 1186129364850448, title: "Ryan Goslin Face Palm"}, {id: 1186129728183745, title: "Harry Potter Eye Roll"}, {id: 1186130348183683, title: "Michael Scott This Is The Worst"}, {id: 1186131988183519, title: "Michael Scott Im Fine/No Im not"}]
  # media_options = {
  #   messaging_type: "UPDATE",
  #   recipient: { id: pick["user"]["facebook_uuid"] },
  #   message: {
  #     attachment: {
  #       type: 'image',
  #       payload: {
  #         attachment_id: loss_gifs.sample[:id]
  #       }
  #     },
  #     quick_replies: menu
  #   }
  # }
  # Bot.deliver(media_options, access_token: ENV['ACCESS_TOKEN'])

end