def listen_for_status
  keywords = ['status', 'streak', 'wins']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, all: true, to: :entry_to_status if matched.any?
end