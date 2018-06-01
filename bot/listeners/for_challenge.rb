def listen_for_challenge
  stop_thread and return if message.text.nil?
  keywords = ['challenge friends', 'challenge', 'challenges', 'my challenges', 'challenge status', 'challenge a friend']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  ignore_words = ['accept', 'decline', 'pending', 'confirm']
  friends_replies = ['Challenge a friend', 'Challenge friends', 'Send challenge', 'Create challenge', 'Make challenge']
  challenges_replies = ['My challenges', 'Active challenges', 'Current challenges']
  bind keywords, all: true, to: :entry_to_challenge, reply_with: {
    text: CHALLENGE.sample,
    quick_replies: [friends_replies.sample, challenges_replies.sample]
  } if matched.any? && !msg.any? { |w| ignore_words.include?(w) } 
end

def listen_for_challenge_postback
  friends_replies = ['Challenge a friend', 'Challenge friends', 'Send challenge', 'Create challenge', 'Make challenge']
  challenges_replies = ['My challenges', 'Active challenges', 'Current challenges']
  bind 'CHALLENGE' do
    say CHALLENGE.sample, quick_replies: [friends_replies.sample, challenges_replies.sample]
    next_command :entry_to_challenge_postback
  end
end