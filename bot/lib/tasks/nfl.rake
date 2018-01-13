namespace :nfl do

desc "Send Reminder"
task :send_reminder do
  puts "Looking to reminders..."
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
    puts "** Message sent for reminders to #{user["name"]} **"
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
        puts "** Message sent for game recap (L) **"
      end
      set_notified pick["id"]
      puts "** Set notification to true **"
    end
  end
end

end