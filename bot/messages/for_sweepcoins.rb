def listen_for_sweepcoins
  for_sweepcoins
end

def for_sweepcoins
  keywords = %w[sweepcoins coins wallet]
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, to: :entry_to_sweepcoins if matched.any?
end