module Commands
  def handle_email
    say "Ok 🤝", quick_replies: ['Select picks', 'Status'] and stop_thread and return if message.quick_reply == 'NEVERMIND'
    confirm_email = message.text.split('@')
    if confirm_email.size > 1
      @api = Api.new
      params = { :user => { :email => message.text } }
      @api.update("users", user.id, params)
      say "🤗"
      short_wait(:message)
      say "I'll store your email as #{message.text} for now\n\nI promise not to send anything without letting you know first 🤝", quick_replies: ['Select picks', 'Status']
      stop_thread
    else
      say "That doesn't sound right..."
      try_again
    end
    stop_thread
  end

  def try_again
    say "Try typing that for me one more time", quick_replies: ['Nevermind']
    next_command :handle_email
  end
end