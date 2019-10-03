def unsubscribe
  
  @sweepy = Sweep::User.find(facebook_uuid: user.id)
  @sweepy.unsubscribe(id: @sweepy.id)
  say "Thanks for trying us out #{@sweepy.first_name}!\n\nI've removed you from any further notifications 🔕."
  stop_thread
  
end