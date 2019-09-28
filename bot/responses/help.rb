def start_help
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Talk to human", payload: "HUMAN"}, {content_type: :text, title: "Prizing", payload: "PRIZING START"}, {content_type: :text, title: "How to play", payload: "HOW TO PLAY START"}]
  say "How can I help, #{sweepy.first_name}?", quick_replies: quick_replies
  stop_thread
  message.typing_off
end

def help
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Status", payload: "STATUS"}]
  say "We're on it, #{sweepy.first_name}. We will reach out to you within the next 24 hours. Thanks for your patience.", quick_replies: quick_replies
  # phone_number = "2054137379"
  phone_number = "4805227771"
  Popcorn.notify(phone_number, "#{sweepy.account.app_name} Customer Support Alert:\n\n#{sweepy.first_name} #{sweepy.last_name}\n#{sweepy.email}\n#{sweepy.zipcode}")
  stop_thread
  message.typing_off
end