def listen_for_actions
  for_lifeline
end

def listen_for_actions_postback
  for_accepting_challenge_requests
  for_denying_challenge_requests
end

def for_lifeline
  @api = Api.new
  @api.fetch_user(user.id)
  keywords = %w[lifeline]
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  if @api.user.data.sweep_coins >= 30
    bind keywords, to: :entry_to_lifeline, reply_with: {
      text: "Are you sure you want me to deduct 30 Sweepcoins from your wallet?",
      quick_replies: [["👍", "Yes Lifeline"], ["👎", "No Lifeline"]]
    } if matched.any?
  else
    bind keywords, to: :entry_to_not_enough_for_lifeline, reply_with: {
      text: "You don't have enough for a lifeline, but feel free to invite or challenge some friends to earn more!",
      quick_replies: ["Invite friends", "Challenge a friend"]
    } if matched.any?
  end
end

def for_accepting_friend_requests
  bind 'ACCEPT CHALLENGE REQUEST', to: :entry_to_accept_challenge_request
end

def for_denying_friend_requests
  bind 'DENY CHALLENGE REQUEST', to: :entry_to_deny_challenge_request
end