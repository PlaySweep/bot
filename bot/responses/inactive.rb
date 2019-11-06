def trigger_offseason
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  say "Thanks for playing the #{sweepy.account.app_name}, #{sweepy.first_name} - we'll be back next year!"
  url = "https://m.me/BudLightSweeps"
  show_button("Play football", "Looking to play some football? Start playing the Bud Light Sweeps 🏈", nil, url)
  stop_thread
end