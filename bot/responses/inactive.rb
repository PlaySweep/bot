def trigger_offseason
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Share", payload: "SHARE"}]
  date = sweepy.account.app_name == "Budweiser Sweep" ? (Date.new(2020, 3, 23) - Date.today).to_i : (Date.new(2020, 9, 10) - Date.today).to_i
  say "The #{sweepy.account.app_name} first contests for the season will be available in #{date} days, #{sweepy.first_name}!"
  stop_thread
end