def listen_for_status
  stop_thread and return if message.text.nil?
  keywords = ['status', 'streak', 'wins']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, all: true, to: :entry_to_status if matched.any?
end

def listen_for_status_postback
  bind 'STATUS', to: :entry_to_status
end