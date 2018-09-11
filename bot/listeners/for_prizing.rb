def listen_for_prizing_postback
  bind 'CASH OUT' do
    @sweepy = Sweep::User.find(user.id)
    if @sweepy.can_cash_out
      sweepcoins_left = (200 - @sweepy.pending_balance)
      quick_replies = [{ content_type: 'text', title: "Go shopping 🛍", payload: "SHOP" }]
      url = "#{ENV['WEBVIEW_URL']}/#{user.id}/sweepcoins"
      show_button("Cash out 🤑", "You have #{@sweepy.data.coins} Sweepcoins 👍", quick_replies, url)
      stop_thread
    else
      if @sweepy.pending_balance == 0
        text = "You have no more Sweepcoins"
        say "#{text}. Keep making picks each day for bonuses and enter FREE tournaments for more chances to win! 🤑"
        stop_thread
      elsif @sweepy.pending_balance == 1
        text = "You have just 1 Sweepcoin"
        say "#{text}. Keep making picks each day for bonuses and enter FREE tournaments for more chances to win! 🤑"
        stop_thread
      else
        sweepcoins_left = (200 - @sweepy.pending_balance)
        options = ["Keep making picks each day for bonuses and enter FREE tournaments for more chances to win! 🤑", "Only #{sweepcoins_left} more to cash out 👍"]
        text = "You have #{@sweepy.pending_balance} Sweepcoins 💰. #{options.sample}"
        say text
        stop_thread
      end
      stop_thread
    end
  end
end

def listen_for_prizing
  stop_thread and return if message.text.nil?
  keywords = ['sweepcoins', 'coins', 'earn', 'cash out', 'cash', 'prizes', 'prize', 'gift card', 'gift cards', 'money', 'prizing', 'payout', 'payment', 'pay out', 'payday', 'pay day', 'pay', 'paid', 'amazon', 'gift', 'card', 'cards']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  @sweepy = Sweep::User.find(user.id)
  bind keywords, all: true, to: :handle_sweepcoins if matched.any?
end