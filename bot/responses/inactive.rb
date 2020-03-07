def trigger_offseason
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Share", payload: "SHARE"}]
  say "The #{sweepy.account.app_name} first contests for the season will be available in 12 days, #{sweepy.first_name}!"
  stop_thread
end