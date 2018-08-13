module Commands
  def handle_email
    say "Ok 🤝", quick_replies: ['Select picks', 'Status'] and stop_thread and return if message.quick_reply == 'NEVERMIND'
    confirm_email = message.text.downcase.split('@')
    if confirm_email.size > 1
      @sweepy = Sweep::User.find(user.id)
      if @sweepy.email.nil?
        params = { :user => { :email => message.text.downcase, :coins => @sweepy.data.coins += 5 } }
        @sweepy.update(params)
        say "Yay 🤗! I have your email as #{message.text.downcase} and added 5 Sweepcoins to your wallet 💌\n\nI promise not to send anything without letting you know first 🤝", quick_replies: ['Select picks', 'Status']
        stop_thread
      elsif @sweepy.email.downcase == message.text.downcase
        say "I already have your email as #{@sweepy.email}, so you're good 👌", quick_replies: ['Make picks', 'Status']
        stop_thread
      elsif !@sweepy.email.nil? && (@sweepy.email.downcase != message.text.downcase)
        params = { :user => { :email => message.text.downcase } }
        @sweepy.update(params)
        say "🤗. I changed your email to #{message.text.downcase} 💌\n\nI promise not to send anything without letting you know first 🤝", quick_replies: ['Select picks', 'Status']
        stop_thread
      end
    else
      say "That doesn't sound right...", quick_replies: ['Email me 💌']
      stop_thread
    end
    stop_thread
  end
end