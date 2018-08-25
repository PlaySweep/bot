def listen_for_unsubscribe
  stop_thread and return if message.text.nil?
  keywords = ['off', 'stop', 'unsubscribe', 'quit', 'leave']
  msg = message.text.split(' ').map(&:downcase).map(&:squeeze)
  matched = (keywords & msg)
  bind keywords, to: :handle_unsubscribe if matched.any?
end