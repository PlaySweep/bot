def listen_for_challenge
  stop_thread and return if message.text.nil?
  keywords = ['challenge friends', 'challenge', 'challenges', 'my challenges', 'challenge status', 'challenge a friend']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  ignore_words = ['accept', 'decline', 'pending', 'confirm']
  bind keywords, all: true, to: :entry_to_challenge, reply_with: {
    text: CHALLENGE.sample,
    quick_replies: ["Challenge friends", "My challenges"]
  } if matched.any? && !msg.any? { |w| ignore_words.include?(w) } 
end

def listen_for_challenge_postback
  bind 'CHALLENGE' do
    say CHALLENGE.sample, quick_replies: ["Challenge friends", "My challenges"]
    next_command :entry_to_challenge_postback
  end
end