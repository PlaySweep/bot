def listen_for_sweepstore
  keywords, msg = ['prizes', 'store', 'sweepstore'], message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, to: :entry_to_sweepstore if matched.any?
end