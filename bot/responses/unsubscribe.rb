def unsubscribe
  # @sweepy = Sweep::User.find(user.id)
  # @sweepy.unsubscribe
  say "I unsubscribed you from any further messages 🔕."
  stop_thread
end