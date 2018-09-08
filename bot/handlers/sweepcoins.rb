module Commands
  def handle_sweepcoins
    @sweepy = Sweep::User.find(user.id)
    if @sweepy.can_cash_out
      sweepcoins_left = (200 - @sweepy.pending_balance)
      quick_replies = [{ content_type: 'text', title: "Make picks", payload: "SELECT PICKS" }, { content_type: 'text', title: "Status", payload: "STATUS" }]
      url = "#{ENV['WEBVIEW_URL']}/sweepcoins"
      show_button("Cash out 🤑", "You have #{@sweepy.data.coins} Sweepcoins 👍", quick_replies, url)
      stop_thread
    else
      if @sweepy.pending_balance == 0
        text = "You have no more Sweepcoins"
      elsif @sweepy.pending_balance == 1
        text = "You have just 1 Sweepcoin"
      else
        sweepcoins_left = (200 - @sweepy.pending_balance)
        text = "You have #{@sweepy.pending_balance} Sweepcoins 💰. Only #{sweepcoins_left} more to cash out 👍"
      end
      stop_thread
    end
  end
end