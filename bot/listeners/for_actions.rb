def listen_for_actions
  for_lifeline
end

def for_lifeline
  keywords = %w[lifeline]
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, to: :entry_to_lifeline, reply_with: {
    text: "Are you sure you want me to deduct 30 Sweepcoins from your wallet?",
    quick_replies: [["👍", "Yes Lifeline"], ["👎", "No Lifeline"]]
  } if matched.any?
end