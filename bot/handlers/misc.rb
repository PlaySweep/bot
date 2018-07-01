module Commands
  def handle_blow_steam
    say ANGRY.sample, quick_replies: ["Select picks", "Status"]
    stop_thread
  end

  def handle_fun
    say FUN.sample, quick_replies: ["Select picks", "Status"]
    stop_thread
  end

  def handle_cash_out
    amount = message.text.to_i
    if amount != 0
      @api = Api.new
      @api.cash_out(user.id, amount)
      say "Cha ching 💰"
      short_wait(:message)
      say "I cashed you out for $#{@api.payment.amount}\n\nCheck your email for next steps..."
      stop_thread
    end
  end
end