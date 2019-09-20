def start_entries
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{content_type: :text, title: "How it works", payload: "ENTRY FAQ"}, {content_type: :text, title: "My entries", payload: "ENTRY DETAILS"}]
  say "How can I help with entries, #{sweepy.first_name}?", quick_replies: quick_replies
  stop_thread
  message.typing_off
end

def general_entry_info
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.roles.first.team_image, payload: "PLAY"}, {content_type: :text, title: "Status", payload: "STATUS"}]
  say "Entries increase your chances of winning the grand prize for each contest. You can earn them the following ways 👇\n\nInvite friends: 1x entry\n\nHit a Sweep: 2x entries\n\nReferred friends hit a Sweep: 5x entries", quick_replies: quick_replies
  stop_thread
  message.typing_off
end

def entry_status
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.roles.first.team_image, payload: "PLAY"}, {content_type: :text, title: "Status", payload: "STATUS"}, {content_type: :text, title: "Share", payload: "SHARE"}]
  say "You currently have 3 entries you can use for your next Sweep!", quick_replies: quick_replies
  stop_thread
  message.typing_off
end