def start_prizes
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "How it works", payload: "PRIZING FAQ"}, {content_type: :text, title: "Where is my prize?", payload: "PRIZING STATUS"}]
  say "How can I help with prizing, #{sweepy.first_name}?", quick_replies: quick_replies
  stop_thread
  message.typing_off
end

def general_prizing_info
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  prizing_copy = sweepy.copies.find { |copy| copy.category == "Prizing Info" }
  quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Status", payload: "STATUS"}]
  say prizing_copy.message, quick_replies: quick_replies
  stop_thread
  message.typing_off
end

def my_prizing_info
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Status", payload: "STATUS"}, {content_type: :text, title: "Help", payload: "HELP"}]
  order = sweepy.recent_orders[0]
  if order
    prize = { name: order.slate.prizes.first.name, slate_name: order.slate.name, date: Date.parse(order.slate.start_time).strftime("%B %d") }
    say "Congratulations again, #{sweepy.first_name}!"
    message.typing_off
    message.typing_on
    say "We are currently processing the #{prize.name} you won on #{prize.date}. Please allow 10-14 business days for shipment of physical items.", quick_replies: quick_replies
    stop_thread
    message.typing_off
  else
    say "We currently do not see any pending prizes for your account.", quick_replies: quick_replies
    stop_thread
    message.typing_off
  end
end