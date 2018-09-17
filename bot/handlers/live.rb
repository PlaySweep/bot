module Commands
  def handle_too_late
    @sweepy = Sweep::User.find(user.id)
    say "Ahhh #{@sweepy.first_name}, you ran out of time on that pick! You've been eliminated from the #{user.session[:event_name]} 🙅."
    stop_thread
  end

  def handle_survivor_pick
    say "✅ #{user.session[:selected_pick]}"
    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/contests?live"
    show_button("LIVE Status 💥", "Tap below to keep up with how things are going 👇", nil, url)
    stop_thread
  end
end