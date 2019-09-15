def send_help
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  say "We will reach out to you within the next 24 hours via email to #{sweepy.email}."
  Popcorn.notify("2054137379", "#{sweepy.account.app_name} help:\n\n#{sweepy.first_name} #{sweepy.last_name}\n#{sweepy.email}")
  stop_thread
  message.typing_off
end