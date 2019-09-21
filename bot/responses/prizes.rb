def start_prizes
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "How it works", payload: "PRIZING FAQ"}, {content_type: :text, title: "Where is my prize?", payload: "PRIZING STATUS"}, {content_type: :text, title: "Current prize", payload: "PRIZING"}]
  say "How can I help with prizing, #{sweepy.first_name}?", quick_replies: quick_replies
  stop_thread
  message.typing_off
end

def general_prizing_info
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  prizing_copy = sweepy.copies.find { |copy| copy.category == "Prizing Info" }
  quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.team_image, payload: "PLAY"}, {content_type: :text, title: "Status", payload: "STATUS"}]
  say prizing_copy.message, quick_replies: quick_replies
  stop_thread
  message.typing_off
end

def current_prizing_info
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "Share with friends", payload: "SHARE"}, {content_type: :text, title: "My entries", payload: "ENTRY DETAILS"}]
  say "We have 2 Browns Tickets up for grabs for the upcoming #{sweepy.current_team.abbreviation} contest! Invite your friends to boost your entries and increase your chances at taking the prize!", quick_replies: quick_replies
  stop_thread
  message.typing_off
end

def my_prizing_info
  message.typing_on
  quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.team_image, payload: "PLAY"}, {content_type: :text, title: "Status", payload: "STATUS"}, {content_type: :text, title: "Help", payload: "HELP"}]
  say "We currently do not see any pending prizes for your account.", quick_replies: quick_replies
  stop_thread
  message.typing_off
end