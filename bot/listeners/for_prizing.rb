def listen_for_prizing
  stop_thread and return if message.text.nil?
  keywords = ['cash out', 'cash', 'prizes', 'prize', 'gift card', 'gift cards', 'money', 'prizing', 'payout', 'payment', 'pay out', 'payday', 'pay day', 'pay', 'paid', 'amazon', 'gift', 'card', 'cards']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  @api = Api.new
  @api.fetch_user(user.id)
  if @api.user.data.can_cash_out? 
   bind keywords, to: :entry_to_cash_out, reply_with: {
     text: "You have #{@api.user.data.pending_balance} Sweepcoins available for a gift card ($#{to_dollars(@api.user.data.sweep_coins)}) 💰\n\nHow many coins do you want to withdrawal?"
   } if matched.any?
  else
    if @api.user.data.pending_balance == 0
      text = "You have no more Sweepcoins"
    elsif @api.user.data.pending_balance == 1
      text = "You have just 1 Sweepcoin"
    else
      text = "You only have #{@api.user.data.pending_balance} Sweepcoins"
    end
    sweepcoins_left = (200 - @api.user.data.pending_balance)
    bind keywords do
      say "#{text} available toward a gift card...\n\n#{sweepcoins_left} more to go 🤑", quick_replies: ['Earn coins']
      stop_thread
    end if matched.any?
  end
end