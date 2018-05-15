def listen_for_sweepcoins
  keywords = %w[sweepcoins coins wallet earn]
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  @api = Api.new
  @api.fetch_user(user.id)
  @api.user.data.sweep_coins == 1 ? sweepcoins = 'Sweepcoin' : sweepcoins = 'Sweepcoins'
  bind keywords, to: :entry_to_sweepcoins, reply_with: {
    text: "Your #{sweepcoins} balance is #{@api.user.data.sweep_coins}\n\nTap the options below for more details 👇",
    quick_replies: ['Earn coins', 'Sweepstore']
  } if matched.any?
end