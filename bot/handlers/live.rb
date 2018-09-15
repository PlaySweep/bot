module Commands
  def handle_too_late
    say "Too late! Missed the deadline"
    stop_thread
  end

  def handle_survivor_pick
    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/contests"
    show_button("Tournament Status", "✅ #{user.session[:selected_pick]}", nil, url)
  end
end