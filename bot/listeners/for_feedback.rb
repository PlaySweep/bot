def listen_for_feedback
  keywords = ['feedback', 'send feedback']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  options = ["I'll send this over to the humans that train me 💫"]
  bind keywords, all: true, to: :entry_to_feedback, reply_with: {
    text: "#{options.sample}\n\nType feedback below 👇"
  } if matched.any?
end