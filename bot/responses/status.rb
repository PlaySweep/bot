def fetch_status
  @sweepy = Sweep::User.find(facebook_uuid: user.id)
  # show_winning_sweep_message if current_status == :winning_sweep
  # show_winning_streak if current_status == :winning_streak
  # show_losing_streak if current_status == :losing_streak
  # show_no_activity if current_status == :no_activity
  show_carousel(elements: status_elements)
  stop_thread
end

def show_winning_sweep_message
  @sweepy.streak == 1 ? dubs = "W" : dubs = "W's"
  text = "You're currently on a Sweep and at #{@sweepy.streak} in a row 🏁"
  url = "#{ENV['WEBVIEW_URL']}/#{user.id}/status"
  show_button("Show me more 🤗", text, nil, url)
  stop_thread
end

def show_winning_streak
  text = "Your streak is currently at #{@sweepy.streak}! Keep it up 🚀"
  url = "#{ENV['WEBVIEW_URL']}/#{user.id}/status"
  show_button("Show Status", text, nil, url)
  stop_thread
end

def show_losing_streak
  text = "Yeah, a losing streak of #{@sweepy.losing_streak} is no bueno, but at least you'll get something for 4 of em' in a row 🤑"
  url = "#{ENV['WEBVIEW_URL']}/#{user.id}/status"
  show_button("Show Status", text, nil, url)
  stop_thread
end

def show_no_activity
  text = "Your streak is at 0 because I haven't closed out any of your picks yet ☺️"
  url = "#{ENV['WEBVIEW_URL']}/#{user.id}/picks"
  show_button("Make Picks NOW 🎉", text, nil, url)
  stop_thread
end

def user_has_sweep?
  @sweepy.streak % 4 == 0
end

def user_has_win_streak?
  @sweepy.streak > 0 && @sweepy.losing_streak < 1
end

def user_has_losing_streak?
  @sweepy.streak < 1 && @sweepy.losing_streak >= 1
end

def user_has_no_activity?
  @sweepy.streak == 0 && @sweepy.losing_streak == 0
end

def current_status
  if user_has_win_streak? && user_has_sweep?
    :winning_sweep
  elsif user_has_win_streak?
    :winning_streak
  elsif user_has_losing_streak?
    :losing_streak
  elsif user_has_no_activity?
    :no_activity
  end
end

def status_elements
  #TODO change image to fb lockup version
  @sweepy = Sweep::User.find(facebook_uuid: user.id)
  [
      {
        title: "Status",
        image_url: "https://budweiser-sweep-assets.s3.amazonaws.com/fb_status_logo2.png",
        subtitle: "Check your results or make any changes before the games start!",
        buttons: [
          {
            type: :web_url,
            url: "#{ENV["WEBVIEW_URL"]}/#{@sweepy.facebook_uuid}/dashboard/initial_load?tab=3",
            title: "Status",
            webview_height_ratio: 'full',
            messenger_extensions: true
          }
        ]
      },
      {
      title: "Road to All-Star Leaderboard",
      image_url: "https://s3.amazonaws.com/budweiser-sweep-assets/allstar_fb_logo.png",
      subtitle: "See how you rank against the competition!",
      buttons: [
        {
          type: :web_url,
          url: "#{ENV["WEBVIEW_URL"]}/#{@sweepy.facebook_uuid}/leaderboard/allstar",
          title: "Leaderboard",
          webview_height_ratio: 'full',
          messenger_extensions: true
        }
      ]
    }
  ]
end