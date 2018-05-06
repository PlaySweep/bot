def listen_for_challenge
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
  bind 'MY CHALLENGES' do
    @api = Api.new
    @api.fetch_user(user.id)
    quick_replies = [{ content_type: 'text', title: "Select picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
    if @api.user.challenges.size > 0
      show_media_with_button(user.id, 'challenges', CHALLENGE_IMAGE, quick_replies)
      stop_thread
    else
      say "You do not have any challenges currently.", quick_replies: ["Challenge friends", "Select picks", "Status"]
      next_command :handle_challenge_intro
    end
  end
end