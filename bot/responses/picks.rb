def fetch_picks
  if matchups_available?
    handle_show_sports
  else
    handle_no_sports_available
  end
end

def matchups_available?
  @slates = Sweep::Slate.all(facebook_uuid: user.id)
  (@slates.nil? || @slates.empty?) ? false : true
end

def handle_show_sports
  options = ["Tap below to see all of the available contests!"]
  url = "#{ENV['WEBVIEW_URL']}/#{user.id}/dashboard/initial_load"
  show_button("Play Now 💥", options.sample, nil, url)
  stop_thread
end

def handle_no_sports_available
  options = [
    "You're all caught up across the board. I'll have more games soon."
  ]

  url = "#{ENV['WEBVIEW_URL']}/#{user.id}/dashboard/initial_load?tab=2"
  show_button("See Answers", options.sample, nil, url)
  stop_thread
end