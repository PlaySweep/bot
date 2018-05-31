def listen_for_feedback
  stop_thread and return if message.text.nil?
  keywords = ['feedback', 'send feedback', 'got questions?', 'help']
  msg = message.text.split(' ').map(&:downcase)
  multiple_keywords, multiple_msg = ['got questions?', 'send feedback', 'need help?'], message.text.split(' ').permutation(2).to_a.map { |m| m.join(' ').downcase } 
  matched, double_matched = (keywords & msg), (multiple_keywords & multiple_msg)
  options = ["I hope you aren't having too many issues 😢", "I totes love feedback 🤗, the constructive kind 🙏"]
  bind keywords, to: :entry_to_feedback, reply_with: {
    text: "#{options.sample}\n\nType your thoughts below and I'll send this over to the humans that train me 💫"
  } if matched.any?
  bind multiple_keywords, to: :entry_to_feedback, reply_with: {
    text: "#{options.sample}\n\nType your thoughts below and I'll send this over to the humans that train me 💫"
  } if double_matched.any?
end