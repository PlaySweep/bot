def unsubscribe
  say "Are you sure you want to be removed from all notifications?", quick_replies: ["Yes", "No"]
  next_command :confirm_unsubscribe
end

def confirm_unsubscribe
  @sweepy = Sweep::User.find(facebook_uuid: user.id)
  case message.quick_reply
  when "YES"
    @sweepy.unsubscribe(uuid: user.id)
    say "Thanks for trying us out #{@sweepy.first_name}!\n\nI've unsubscribed you from any further messages 🔕."
    stop_thread
  when "NO"
    say "Thanks for sticking around #{@sweepy.first_name}!"
    stop_thread
  end
end