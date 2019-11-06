def trigger_offseason
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  say "Thanks for the playing the #{sweepy.account.app_name}, #{sweepy.first_name} - we'll be back next year!\n\nLooking to play some football? Tap below to check out the Bud Light Sweeps!"
  url = "https://m.me/BudLightSweeps"
  show_button("Play football", "Start playing the Bud Light Sweeps 🏈", nil, url)
  stop_thread
end