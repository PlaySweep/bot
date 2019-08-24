def show_prizes
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  prizing_copy = sweepy.copies.find { |copy| copy.category == "Prizing Info" }
  say prizing_copy.message
  stop_thread
end