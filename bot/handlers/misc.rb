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
    @api = Api.new
    @api.fetch_user(user.id)
    if @api.user.email
      amount = message.text.to_i
      if @api.user.data.pending_balance >= amount
        if amount != 0 && amount >= 200
          @api = Api.new
          @api.cash_out(user.id, amount)
          say "Cha ching 💰"
          short_wait(:message)
          say "You should be receiving an email with your Amazon gift card for $#{@api.payment.amount} any minute now 👍", quick_replies: ['Make picks', 'Status']
          stop_thread
        else
          say "I can't cash you out for less than 200 Sweepcoins..."
          short_wait(:message)
          say "When you're ready to withdrawal more, just type 'Cash out' below 👇"
          stop_thread
        end
      else
        say "You do not have enough Sweepcoins to withdrawal that amount..."
        short_wait(:message)
        say "When you're ready again, just type 'Cash out' below 👇"
        stop_thread
      end
    else
      user.session[:payout] = message.text.to_i
      if @api.user.data.pending_balance >= user.session[:payout]
        if user.session[:payout] != 0 && user.session[:payout] >= 200
          say "Great, I'll generate a gift card for $#{to_dollars(user.session[:payout])} 👍"
          short_wait(:message) 
          say "I'll need an email so I know where to send it to 😊", quick_replies: EMAIL_PROMPT
          next_command :get_email_and_cash_out
        else
          say "I can't generate a gift card for less than 200 Sweepcoins..."
          short_wait(:message)
          say "When you're ready to withdrawal more, just type 'Cash out' below 👇"
          stop_thread
        end
      else
        say "You do not have enough Sweepcoins to generate a gift card with that amount..."
        short_wait(:message)
        say "When you're ready again, just type 'Cash out' below 👇"
        stop_thread
      end
    end
  end

  def get_email_and_cash_out
    say "If you're having problems cashing out, you can email my developer at hi@playsweep.com 🤓" and stop_thread if message.text.downcase == 'nevermind'
    email = message.text.downcase
    if is_a_valid_email?(email)
      @api = Api.new
      params = { :user => { :email => message.text.downcase } }
      @api.update("users", user.id, params)
      @api.cash_out(user.id, user.session[:payout])
      say "Cha ching 💰"
      short_wait(:message)
      say "You should be receiving an email with your Amazon gift card for $#{@api.payment.amount} any minute now 👍", quick_replies: ['Make picks', 'Status']
      stop_thread
    else
      say "Whoops, that didn't look like a valid email...just type your email below 👍", quick_replies: ['Nevermind']
      next_command :get_email_and_cash_out
    end
  end
end