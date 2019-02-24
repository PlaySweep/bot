def location
  say "Let me check on that, send me your current location by tapping below 👇", quick_replies: UI::QuickReplies.location
  next_command :fetch_location_response
end

def fetch_location_response
  say "Nice, I see you are in Austin, TX. I don't see any local events for this area yet, but I'll let you know as soon as we do!"
  stop_thread
end