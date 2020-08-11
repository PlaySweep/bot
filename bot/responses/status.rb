def fetch_status
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  fetch_picks
  stop_thread
end