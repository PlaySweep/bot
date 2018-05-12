def listen_for_feedback
  keywords = ['feedback', 'send feedback']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, all: true, to: :entry_to_feedback, reply_with: {
    text: "Say what ya need to say..."
  } if matched.any?
end