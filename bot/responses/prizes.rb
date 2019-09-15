def show_prizes
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  prizing_copy = sweepy.copies.find { |copy| copy.category == "Prizing Info" }
  say prizing_copy.message
  stop_thread
  message.typing_off
end