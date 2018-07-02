def listen_for_prizing
  stop_thread and return if message.text.nil?
  keywords = ['cash out', 'cash', 'prizes', 'prize', 'gift card', 'money', 'prizing']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  @api = Api.new
  @api.fetch_user(user.id)
  if @api.user.data.pending_balance >= 100  
   bind keywords, to: :entry_to_cash_out, reply_with: {
     text: "You have #{@api.user.data.pending_balance} Sweepcoins available for cash out ($#{to_dollars(@api.user.data.sweep_coins)}) 💰\n\nHow many coins do you want to withdrawal?"
   } if matched.any?
  else
    if @api.user.data.pending_balance == 0
      text = "You have no more Sweepcoins"
    elsif @api.user.data.pending_balance == 1
      text = "You have just 1 Sweepcoin"
    else
      text = "You only have #{@api.user.data.pending_balance} Sweepcoins"
    end
    bind keywords, to: :entry_to_cash_out, reply_with: {
      text: "#{text} available for cash out\n\nYou need at least 100 🤑"
    } if matched.any?
    stop_thread
  end
end