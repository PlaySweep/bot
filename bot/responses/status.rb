require 'possessive'

def fetch_status
  # if there is no pending game or started game
  # if there is a pending game and user has not played
  # if there is a pending game and user has played
  # if there is a started game and user has played
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Play again", payload: "PLAY"}]
  say "Here's your latest stats, #{sweepy.first_name} 👇\n\nYour last score was close, hitting #{sweepy.stats.last_score} out of 6 questions right. You've hit #{sweepy.stats.sweep_count} total Sweeps and have a current streak of #{sweepy.stats.current_pick_streak} in a row going into the next contest.\n\nKeep it up, #{sweepy.first_name}!"
  fetch_picks
  stop_thread
  message.typing_off
end

def status_elements
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  if sweepy.roles.first
    contest_copy = sweepy.copies.find { |copy| copy.category == "Contest Subtitle" }
    interpolated_contest_copy = contest_copy.message % { team_abbreviation: sweepy.roles.first.abbreviation }
    [
      {
        title: "#{sweepy.roles.first.abbreviation.possessive} Contests",
        image_url: sweepy.roles.first.team_entry_image,
        subtitle: interpolated_contest_copy,
        buttons: [
          {
            type: :web_url,
            url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{sweepy.slug}/1",
            title: "More contests",
            webview_height_ratio: 'full',
            messenger_extensions: true
          },
          {
            type: :web_url,
            url: "#{ENV["WEBVIEW_URL"]}/dashboard/#{sweepy.slug}/2",
            title: "See results",
            webview_height_ratio: 'full',
            messenger_extensions: true
          }
        ]
      }
    ]
  end
end