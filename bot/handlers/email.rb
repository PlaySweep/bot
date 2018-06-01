module Commands
  def handle_email
    say "Ok 🤝", quick_replies: ['Select picks', 'Status'] and stop_thread and return if message.quick_reply == 'NEVERMIND'
    confirm_email = message.text.downcase.split('@')
    if confirm_email.size > 1
      @api = Api.new
      @api.fetch_user(user.id)
      if @api.user.email.nil?
        params = { :user => { :email => message.text.downcase, :sweep_coins => @api.user.data.sweep_coins += 5 } }
        @api.update("users", user.id, params)
        short_wait(:message)
        say "Yay 🤗"
        short_wait(:message)
        say "I have your email as #{message.text.downcase} and added 5 Sweepcoins to your wallet 💌\n\nI promise not to send anything without letting you know first 🤝", quick_replies: ['Select picks', 'Status']
        stop_thread
      elsif @api.user.email.downcase == message.text.downcase
        short_wait(:message)
        say "I already have your email as #{@api.user.email}, so you're good 👌", quick_replies: ['Make picks', 'Status']
        stop_thread
      elsif !@api.user.email.nil? && (@api.user.email.downcase != message.text.downcase)
        params = { :user => { :email => message.text.downcase } }
        @api.update("users", user.id, params)
        short_wait(:message)
        say "🤗"
        short_wait(:message)
        say "I changed your email to #{message.text.downcase} 💌\n\nI promise not to send anything without letting you know first 🤝", quick_replies: ['Select picks', 'Status']
        stop_thread
      end
    else
      say "That doesn't sound right...", quick_replies: ['Email me 💌']
      stop_thread
    end
    stop_thread
  end
end