def trigger_offseason
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  url = "https://m.me/BudLightSweeps"
  say "Thanks for playing the #{sweepy.account.app_name}, #{sweepy.first_name} - we'll be back next year!"
  say "Looking to play some football? Start playing the Bud Light Sweeps by following the link below 🏈\n\n#{url}"
  stop_thread
end