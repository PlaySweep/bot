namespace :nfl do

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
    message_options = {
      messaging_type: "UPDATE",
      recipient: { id: user["user"]["facebook_uuid"] },
      message: {
        text: "Hey #{user["user"]["first_name"]} 👋, select your picks for the upcoming games!",
        quick_replies: menu
      }
    }
    Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
    sleep 1
    reminder_gifs = [{id: 1517413058307731, title: "Jennifer Lawrence Thumbs Up"}]
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
    sleep 300 if index % 20 == 0
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
      if pick["user"]["notification_settings"]["recap_all"]
        emoji = "🔥"
        wins = pick["user"]["current_streak"] == 1 ? "win" : "wins"
        symbol = pick["spread"] > 0 ? "+" : ""
        text = "The #{pick["team_abbrev"]} (#{symbol}#{pick["spread"]}) covered the spread against the #{pick["opponent_abbrev"]} with the final score of #{pick["matchup"]["winner_score"]} to #{pick["matchup"]["loser_score"]}."
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
        win_gifs = [{id: 1517896908259346, title: "Keanu Reeves Thumbs Up"}, {id: 1517900044925699, title: "Sean Connery Fist Pump"}]
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
        symbol = pick["spread"] > 0 ? "+" : ""
        emoji = "😑"
        custom_text = your_score > opponent_score ? "Although the #{pick["team_abbrev"]} won #{your_score} to #{opponent_score}, they did not cover the spread (#{symbol}#{pick["spread"]}) against the #{pick["opponent_abbrev"]}." : "The #{pick["team_abbrev"]} (#{symbol}#{pick["spread"]}) did not cover the spread against the #{pick["opponent_abbrev"]} with the final score of #{pick["matchup"]["loser_score"]}-#{pick["matchup"]["winner_score"]}."
        message_options = {
          messaging_type: "UPDATE",
          recipient: { id: pick["user"]["facebook_uuid"] },
          message: {
            text: "#{custom_text}\n\n#{emoji} Your current streak has been set back to #{pick["user"]["current_streak"]}.",
            quick_replies: menu
          }
        }
        Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
        sleep 1
        loss_gifs = [{id: 1517902454925458, title: "Ryan Gosling Face Palm"}, {id: 1517903024925401, title: "Harry Potter Eye Roll"}, {id: 1517906254925078, title: "Michael Scott Im Fine/No Im not"}]
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