def listen_for_friends
  keywords = ['challenge friends', 'add friends', 'my friends', 'challenge', 'challenge a friend']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, all: true, to: :entry_to_friends, reply_with: {
    text: "Get your friends involved",
    quick_replies: ["Challenge a friend"]
  } if matched.any?
end

def listen_for_friends_postback
  bind 'FRIENDS' do
    say "Get your friends involved", quick_replies: ["Challenge a friend"]
    next_command :entry_to_friends_postback
  end
end