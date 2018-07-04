def listen_for_sweepcoins
  stop_thread and return if message.text.nil?
  keywords = %w[sweepcoins coins wallet balance]
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  @api = Api.new
  @api.fetch_user(user.id)
  if @api.user.data.sweep_coins >= 100
    options = ["You are so money, and you don't even know it...ok maybe you do 🤑", "I wish I had that many Bitcoins 🤓"]
  elsif @api.user.data.sweep_coins >= 50 && @api.user.data.sweep_coins < 100 
    options = ["At least you still have enough for some lifelines 🙏"]
  elsif @api.user.data.sweep_coins >= 25 && @api.user.data.sweep_coins < 50
    options = ["You may be running a little low, but have you seen my actual bank account? 😳"]
  else
    options = ["Don't worry, I have a spending problem too 🤐"]
  end
  if @api.user.data.sweep_coins >= 100
    bind keywords, to: :entry_to_sweepcoins, reply_with: {
      text: "Your Sweepcoin balance is #{@api.user.data.sweep_coins}\n\n#{options.sample}",
      quick_replies: ['Cash out', 'Earn coins']
    } if matched.any?
  else
    bind keywords, to: :entry_to_earning_coins if matched.any?
  end
end