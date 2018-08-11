def listen_for_prizing
  stop_thread and return if message.text.nil?
  keywords = ['sweepcoins', 'coins', 'earn', 'cash out', 'cash', 'prizes', 'prize', 'gift card', 'gift cards', 'money', 'prizing', 'payout', 'payment', 'pay out', 'payday', 'pay day', 'pay', 'paid', 'amazon', 'gift', 'card', 'cards']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  @sweepy = Sweep::User.find(user.id)
  bind keywords, all: true, to: :handle_sweepcoins if matched.any?
end