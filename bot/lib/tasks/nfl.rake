namespace :nfl do

desc "Send Reminder"
task :send_reminder do
  puts "Looking to **Send Reminder**"
  get_users_with_reminders
  menu = [
    {
      content_type: 'text',
      title: 'Update picks',
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
  @users.each do |user|
    message_options = {
      messaging_type: "UPDATE",
      recipient: { id: user["user"]["facebook_uuid"] },
      message: {
        text: "Hey #{user["user"]["first_name"]} 👋, you still haven't made any picks for the day, but you've still got time!",
        quick_replies: menu
      }
    }
    Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
    puts "**Send Reminder** sent to #{user.inspect}"
  end
end

desc "Send Game Recap"
task :send_notification do
  puts "Looking to **Send Game Recap**"
  get_recently_completed
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
  @recently_completed.each do |pick|
    if pick["result"] == "W"
      puts "Notifying #{pick["team_abbrev"]}..."
      if pick["user"]["notification_settings"]["recap_all"]
        emoji = "🔥"
        wins = pick["user"]["current_streak"] == 1 ? "win" : "wins"
        symbol = pick["spread"] > 0 ? "+" : ""
        text = "Nice win #{pick["user"]["first_name"]}! The #{pick["team_abbrev"]} (#{symbol}#{pick["spread"]}) covered the spread against the #{pick["opponent_abbrev"]} with the final score of #{pick["matchup"]["winner_score"]}-#{pick["matchup"]["loser_score"]}."
        message_options = {
          messaging_type: "UPDATE",
          recipient: { id: pick["user"]["facebook_uuid"] },
          message: {
            text: "#{text}\n\n#{emoji} You now have #{pick["user"]["current_streak"]} #{wins} in a row",
            quick_replies: menu
          }
        }
        Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
        puts "**Send Game Recap Win** sent"
      end
    end
      
    if pick["result"] == "L"
      puts "Notifying #{pick["team_abbrev"]}..."
      if pick["user"]["notification_settings"]["recap_loss"]
        emoji = "🤷"
        symbol = pick["spread"] > 0 ? "+" : ""
        text = "Bummer #{pick["user"]["first_name"]}. The #{pick["team_abbrev"]} (#{symbol}#{pick["spread"]}) did not cover the spread against the #{pick["opponent_abbrev"]} with the final score of #{pick["matchup"]["loser_score"]}-#{pick["matchup"]["winner_score"]}."
        message_options = {
          messaging_type: "UPDATE",
          recipient: { id: pick["user"]["facebook_uuid"] },
          message: {
            text: "#{text}\n\n#{emoji} You now have #{pick["user"]["current_streak"]} wins in a row",
            quick_replies: menu
          }
        }
        Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
        puts "**Send Game Recap Loss** sent"
      end
    end
    set_notified pick["id"]
    puts "Notified pick id: #{pick["id"]}"
  end
end
end