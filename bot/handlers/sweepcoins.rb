module Commands
  def handle_sweepcoins
    say "In case you need a reminder, the best ways to earn coins are to invite your friends, stay active, and WIN challenges against your friends 🏆", quick_replies: ['Invite friends', 'Challenges', 'Make picks'] and stop_thread and return if !message.quick_reply
    if message.quick_reply == "CASH OUT"
      @api = Api.new
      @api.fetch_user(user.id)
      bind 'CASH OUT', to: :entry_to_cash_out, reply_with: {
        text: "You have #{@api.user.data.pending_balance} Sweepcoins available for cash out ($#{to_dollars(@api.user.data.sweep_coins)}) 💰\n\nHow many coins do you want to withdrawal?"
      }
    elsif message.quick_reply == "EARN COINS"
      quick_replies = [{ content_type: 'text', title: "Make picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
      url = "#{ENV['WEBVIEW_URL']}/sweepcoins"
      show_button("Earn Sweepcoins", "Tap below to see a list of ways to earn more 👇", quick_replies, url)
      stop_thread
    end
  end

  def handle_earning_coins
    @api = Api.new
    @api.fetch_user(user.id)
    say "Your Sweepcoin balance is #{@api.user.data.sweep_coins}..."
    short_wait(:message)
    quick_replies = [{ content_type: 'text', title: "Make picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
    url = "#{ENV['WEBVIEW_URL']}/sweepcoins"
    show_button("Earn Sweepcoins", "Tap below to see a list of ways to earn more 👇", quick_replies, url)
    stop_thread
  end

end