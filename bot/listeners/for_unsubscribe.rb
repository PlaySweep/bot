def listen_for_unsubscribe
  stop_thread and return if message.text.nil?
  keywords = ['stop', 'unsubscribe', 'quit', 'leave']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, to: :handle_unsubscribe if matched.any?
end