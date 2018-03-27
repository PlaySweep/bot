# [1566539433429514, 1827403637334265].each do |sweep_user_id|
#   message_options = {
#     messaging_type: "UPDATE",
#     recipient: { id: sweep_user_id },
#     message: {
#       text: "Feedback from #{full_name}\n\n#{message.text}"
#     }
#   }
#   Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
# end

desc "Test Reminder"
task :test_all do
  get_users
  puts "Users..."
  puts @users.inspect
  @users[0..5].each_with_index do |user|
    puts user["user"]["facebook_uuid"]
    puts user["user"]["first_name"]
  end
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
      title: 'Invite friends',
      payload: 'Invite friends'
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
      text: "The time of refreshing the price of Bitcoin is over Ryan, Super Bowl LII is upon us 🏈!",
      quick_replies: menu
    }
  }
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
end

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
  # reminder_gifs = [{id: 1517926024923101, title: "Jennifer Lawrence Thumbs Up"}]
  reminder_gifs = [{id: 1531725230209847, title: "Django/Dicaprio"}, {id: 1531725626876474, title: "Galaxy Quest"}, {id: 1531726016876435, title: "Ok lets ride"}, {id: 1531738010208569, title: "500 Days of Summer/Dance"}]
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
      payload: 'invite friends'
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
  # win_gifs = [{id: 1517896908259346, title: "Keanu Reeves Thumbs Up"}, {id: 1517900044925699, title: "Sean Connery Fist Pump"}, {id: 1517919341590436, title: "Nicolas Cage Con Air"}, {id: 1517920478256989, title: "Beard Man Happy Approval"}, {id: 1517922411590129, title: "Black Guy On Pier Dusting Hands Off"}]
  win_gifs = [{id: 1531724076876629, title: "Nacho Libre"}, {id: 1531724233543280, title: "Brad Pitt"}, {id: 1531724490209921, title: "Antonio Banderas"}, {id: 1531724726876564, title: "Big Lebowski"}, {id: 1531725003543203, title: "Stranger Things"}, {id: 1531737493541954, title: "500 Days of Summer"}, {id: 1531737686875268, title: "James Franco Wink"}]
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
  # loss_gifs = [{id: 1517902454925458, title: "Ryan Gosling Face Palm"}, {id: 1517903024925401, title: "Harry Potter Eye Roll"}, {id: 1517906254925078, title: "Michael Scott Im Fine/No Im not"}]
  loss_gifs = [{id: 1531717616877275, title: "Dumb and Dumber"}, {id: 1531717936877243, title: "True Detective"}, {id: 1531718323543871, title: "Leo Dicaprio/Titanic"}, {id: 1531718760210494, title: "Bill Murray"}, {id: 1531737016875335, title: "500 Days of Summer/Elevator"}, {id: 1531737290208641, title: "Zooey Deschanel"}]
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