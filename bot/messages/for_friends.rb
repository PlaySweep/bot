def listen_for_friends
  keywords = ['friends', 'add friends', 'my friends', 'challenge', 'challenge a friend']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, all: true, to: :entry_to_friends, reply_with: {
    text: "Get your friends involved",
    quick_replies: ["Challenge a friend", "Find friends"]
  } if matched.any?
end