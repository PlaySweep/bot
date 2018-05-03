def listen_for_challenge
  keywords = ['challenge friends', 'challenge', 'challenges', 'my challenges', 'challenge status', 'challenge a friend']
  # msg = message.text.split(' ').map(&:downcase)
  # matched = (keywords & msg)
  bind keywords, all: true, to: :entry_to_challenge, reply_with: {
    text: CHALLENGE.sample,
    quick_replies: ["Challenge friends", "My challenges"]
  } unless ['accept', 'accept challenge', 'decline', 'decline challenge'].include?(message.text.downcase)
end

def listen_for_challenge_postback
  bind 'CHALLENGE' do
    say CHALLENGE.sample, quick_replies: ["Challenge friends", "My challenges"]
    next_command :entry_to_challenge_postback
  end
end