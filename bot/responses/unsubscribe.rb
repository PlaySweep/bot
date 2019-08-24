def unsubscribe
  @sweepy = Sweep::User.find(facebook_uuid: user.id)
  @sweepy.unsubscribe(id: @sweepy.id)
  say "Thanks for trying us out #{@sweepy.first_name}!\n\nI've removed you from any further messages 🔕."
  stop_thread
end

def confirm_unsubscribe
  @sweepy = Sweep::User.find(facebook_uuid: user.id)
  case message.quick_reply
  when "YES"
   @sweepy.unsubscribe(id: @sweepy.id)
    say "Thanks for trying us out #{@sweepy.first_name}!\n\nI've unsubscribed you from any further messages 🔕."
    stop_thread
  when "NO"
    say "Thanks for sticking around #{@sweepy.first_name}!"
    stop_thread
  else
   @sweepy.unsubscribe(id: @sweepy.id)
    stop_thread
  end
end