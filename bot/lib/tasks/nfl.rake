namespace :nfl do
desc "Send Reminder to all"
task :to_all do
  get_users
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
  @users.each_with_index do |user, index|
    begin
      message_options = {
        messaging_type: "UPDATE",
        recipient: { id: user["user"]["facebook_uuid"] },
        message: {
          text: "The time of refreshing the price of Bitcoin is over #{user["user"]["first_name"]}, Super Bowl LII is upon us 🏈!",
          quick_replies: menu
        }
      }
      Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
      sleep 1
      reminder_gifs = [{id: 1531726016876435, title: "Ok, Lets ride"}]
      media_options = {
        messaging_type: "UPDATE",
        recipient: { id: user["user"]["facebook_uuid"] },
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
      puts "** Message sent for reminders to #{user["user"]['first_name']} #{user["user"]['last_name']} **"
      sleep 120 if index % 20 == 0
    rescue Facebook::Messenger::FacebookError => e
      puts "User: #{user["user"]['first_name']} #{user["user"]['last_name']} can not be reached..."
      next
    end
  end
end

desc "Send Reminder"
task :send_reminder do
  puts "Looking to reminders..."
  get_users_with_reminders
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
  @users.each_with_index do |user, index|
    begin
      message_options = {
        messaging_type: "UPDATE",
        recipient: { id: user["user"]["facebook_uuid"] },
        message: {
          text: "Alright #{user["user"]["first_name"]}, the Super Bowl props are here 🏈! Select picks now!",
          quick_replies: menu
        }
      }
      Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
      sleep 1
      reminder_gifs = [{id: 1531726016876435, title: "Ok, Lets ride"}]
      media_options = {
        messaging_type: "UPDATE",
        recipient: { id: user["user"]["facebook_uuid"] },
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
      puts "** Message sent for reminders to #{user["name"]} **"
      sleep 120 if index % 20 == 0
    rescue Facebook::Messenger::FacebookError => e
      puts "User: #{user["user"]['first_name']} #{user["user"]['last_name']} can not be reached..."
      next
    end
  end
end

desc "Send Game Recap"
task :send_notification do
  puts "Looking to send game recaps..."
  get_recently_completed
  @recently_completed.each do |pick|
    if pick["result"] == "W"
      menu = [
        {
          content_type: 'text',
          title: 'Invite friends',
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

      if pick["user"]["notification_settings"]["recap_all"] && pick["user"]["current_streak"] % 4 != 0
        emoji = "🔥"
        wins = pick["user"]["current_streak"] == 1 ? "win" : "wins"
        # symbol = pick["spread"] > 0 ? "+" : ""
        text = "#{pick["selection"]} won!"
        message_options = {
          messaging_type: "UPDATE",
          recipient: { id: pick["user"]["facebook_uuid"] },
          message: {
            text: "#{text}\n\n#{emoji} You now have #{pick["user"]["current_streak"]} #{wins} in a row",
            quick_replies: menu
          }
        }
        Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
        sleep 1
        # win_gifs = [{id: 1517896908259346, title: "Keanu Reeves Thumbs Up"}, {id: 1517900044925699, title: "Sean Connery Fist Pump"}, {id: 1517919341590436, title: "Nicolas Cage Con Air"}, {id: 1517920478256989, title: "Beard Man Happy Approval"}, {id: 1517922411590129, title: "Black Guy On Pier Dusting Hands Off"}]
        win_gifs = [{id: 1531725626876474, title: "Galaxy Quest"}, {id: 1531724076876629, title: "Nacho Libre"}, {id: 1531724233543280, title: "Brad Pitt"}, {id: 1531724490209921, title: "Antonio Banderas"}, {id: 1531724726876564, title: "Big Lebowski"}, {id: 1531725003543203, title: "Stranger Things"}, {id: 1531737493541954, title: "500 Days of Summer"}, {id: 1531737686875268, title: "James Franco Wink"}]
        media_options = {
          messaging_type: "UPDATE",
          recipient: { id: pick["user"]["facebook_uuid"] },
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
        puts "** Message sent for game recap (W) **"
      elsif pick["user"]["notification_settings"]["recap_all"] && pick["user"]["current_streak"] % 4 == 0
        # symbol = pick["spread"] > 0 ? "+" : ""
        text = "You hit a Sweep 🎉\n\n#{pick["selection"]} won!"
        message_options = {
          messaging_type: "UPDATE",
          recipient: { id: pick["user"]["facebook_uuid"] },
          message: {
            text: "#{text}\n\nYou now have #{pick["user"]["current_streak"]} in a row, go spread the word 🎙️👍",
            quick_replies: menu
          }
        }
        Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
        sleep 1
        sweep_gifs = [{id: 1531725230209847, title: "Django/Dicaprio"}, {id: 1531738010208569, title: "500 Days of Summer/Dance"}]
        media_options = {
          messaging_type: "UPDATE",
          recipient: { id: pick["user"]["facebook_uuid"] },
          message: {
            attachment: {
              type: 'image',
              payload: {
                attachment_id: sweep_gifs.sample[:id]
              }
            },
            quick_replies: menu
          }
        }
        Bot.deliver(media_options, access_token: ENV['ACCESS_TOKEN'])
      end
      set_notified pick["id"]
      puts "** Set notified to true **"
    end
      
    if pick["result"] == "L"
      menu = [
        {
          content_type: 'text',
          title: 'Earn mulligans',
          payload: 'Earn mulligans'
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
      if pick["user"]["notification_settings"]["recap_loss"]
        your_score = pick["matchup"]["loser_score"]
        opponent_score = pick["matchup"]["winner_score"]
        # symbol = pick["spread"] > 0 ? "+" : ""
        emoji = "😑"
        # custom_text = your_score > opponent_score ? "Although the #{pick["team_abbrev"]} won #{your_score} to #{opponent_score}, they did not cover the spread (#{symbol}#{pick["spread"]}) against the #{pick["opponent_abbrev"]}." : "The #{pick["team_abbrev"]} (#{symbol}#{pick["spread"]}) did not cover the spread against the #{pick["opponent_abbrev"]} with the final score of #{pick["matchup"]["loser_score"]}-#{pick["matchup"]["winner_score"]}."
        message_options = {
          messaging_type: "UPDATE",
          recipient: { id: pick["user"]["facebook_uuid"] },
          message: {
            text: "#{pick["selection"]} lost.\n\nYour current streak has been set back to #{pick["user"]["current_streak"]}.",
            quick_replies: menu
          }
        }
        Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
        sleep 1
        # loss_gifs = [{id: 1517902454925458, title: "Ryan Gosling Face Palm"}, {id: 1517903024925401, title: "Harry Potter Eye Roll"}, {id: 1517906254925078, title: "Michael Scott Im Fine/No Im not"}]
        loss_gifs = [{id: 1531717616877275, title: "Dumb and Dumber"}, {id: 1531717936877243, title: "True Detective"}, {id: 1531718323543871, title: "Leo Dicaprio/Titanic"}, {id: 1531718760210494, title: "Bill Murray"}, {id: 1531737016875335, title: "500 Days of Summer/Elevator"}, {id: 1531737290208641, title: "Zooey Deschanel"}]
        media_options = {
          messaging_type: "UPDATE",
          recipient: { id: pick["user"]["facebook_uuid"] },
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
        puts "** Message sent for game recap (L) **"
      end
      set_notified pick["id"]
      puts "** Set notification to true **"
    end
  end
end

end