namespace :nfl do

desc "Select Picks Reminder"
task :send_notification do
  get_picks
  menu = [
    {
      content_type: 'text',
      title: 'Status',
      payload: 'STATUS'
    },
    {
      content_type: 'text',
      title: 'Select picks',
      payload: 'SELECT PICKS'
    },
    {
      content_type: 'text',
      title: 'Invite Friends',
      payload: 'Invite friends'
    }
  ]
  @picks.each do |pick|
    if pick["result"] == "W" && pick["user"]["notification_settings"]["recap_all"]
      emoji = "🔥"
      wins = pick["user"]["current_streak"] == 1 ? "win" : "wins"
      symbol = pick["spread"] > 0 ? "+" : ""
      text = "The #{pick["team_abbrev"]} (#{symbol}#{pick["spread"]}) beat the #{pick["opponent_abbrev"]} #{pick["matchup"]["winner_score"]}-#{pick["matchup"]["loser_score"]}."
      message_options = {
        messaging_type: "UPDATE",
        recipient: { id: pick["user"]["facebook_uuid"] },
        message: {
          text: "#{text}\n\n#{emoji} You now have #{pick["user"]["current_streak"]} #{wins} in a row",
          quick_replies: menu
        }
      }
      Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
      puts "Delivered win message...for #{pick.inspect}"
    elsif pick["result"] == "L" && pick["user"]["notification_settings"]["recap_loss"]
      emoji = "🤷"
      symbol = pick["spread"] > 0 ? "+" : ""
      text = "The #{pick["team_abbrev"]} (#{symbol}#{pick["spread"]}) lost to the #{pick["opponent_abbrev"]} #{pick["matchup"]["loser_score"]}-#{pick["matchup"]["winner_score"]}."
      message_options = {
        messaging_type: "UPDATE",
        recipient: { id: pick["user"]["facebook_uuid"] },
        message: {
          text: "#{text}\n\n#{emoji} You now have #{pick["user"]["current_streak"]} wins in a row",
          quick_replies: menu
        }
      }
      Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
      puts "Delivered loss message...for #{pick.inspect}"
    else
      puts "Reminders not set for #{pick["user"]}"
    end
  end
end
end