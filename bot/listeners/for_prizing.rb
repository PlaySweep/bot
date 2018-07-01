def listen_for_prizing
  stop_thread and return if message.text.nil?
  keywords = ['cash out', 'cash', 'prizes', 'prize', 'gift card', 'money', 'prizing']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  @api = Api.new
  @api.fetch_user(user.id)
  if @api.user.data.sweep_coins >= 100  
   bind keywords, to: :entry_to_cash_out, reply_with: {
     text: "You have #{@api.user.data.sweep_coins} Sweepcoins 💰\n\nHow much would you like to cash out for?"
   } if matched.any?
  else
    bind keywords, to: :entry_to_cash_out, reply_with: {
      text: "You only have #{@api.user.data.sweep_coins}, you need at least 100 Sweepcoins to be able to cash out."
    } if matched.any?
  end
end