module Commands
  def how_to_play
    @api = Api.new
    @api.find_or_create('users', user.id)
    if @api.user.data.how_to_play_touched
      message.typing_on
      say "If you say 'Make picks', 'Status' or 'Help', I will respond accordingly 💁"
      sleep 2
      message.typing_on
      sleep 1
      say "I've also put some helpful buttons at the bottom of the screen and inside the menu for speediness 😉", quick_replies: [['Picking games', 'Picking games'], ['Prizes', 'Prizes']]
      stop_thread
    else
      set('how to play touched', user.id)
      message.typing_on
      sleep 0.5
      say "Hey #{@api.user.first_name} 👋"
      sleep 0.5
      message.typing_on
      sleep 0.5
      say "One of the best ways to get unstuck is to simply write to me ✍️"
      sleep 1.5
      say "For example..."
      sleep 0.5
      message.typing_on
      sleep 0.5
      say "If you say 'Make picks', 'Status' or 'Help', I will respond accordingly 💁"
      sleep 2
      message.typing_on
      sleep 1
      say "I've also put some helpful buttons at the bottom of the screen and inside the menu for speediness 😉", quick_replies: [['Picking games', 'Picking games'], ['Prizes', 'Prizes']]
      stop_thread
    end
  end

  def how_to_play_for_postback
    @api = Api.new
    @api.find_or_create('users', user.id)
    if @api.user.data.how_to_play_touched
      postback.typing_on
      say "If you say 'Make picks', 'Status' or 'Help', I will respond accordingly 💁"
      sleep 2
      postback.typing_on
      sleep 1
      say "I've also put some helpful buttons at the bottom of the screen and inside the menu for speediness 😉", quick_replies: [['Picking games', 'Picking games'], ['Prizes', 'Prizes']]
      stop_thread
    else
      set('how to play touched', user.id)
      postback.typing_on
      sleep 0.5
      say "Hey #{@api.user.first_name} 👋"
      sleep 0.5
      postback.typing_on
      sleep 0.5
      say "One of the best ways to get unstuck is to simply write to me ✍️"
      sleep 1.5
      say "For example..."
      sleep 0.5
      postback.typing_on
      sleep 0.5
      say "If you say 'Make picks', 'Status' or 'Help', I will respond accordingly 💁"
      sleep 2
      postback.typing_on
      sleep 1
      say "I've also put some helpful buttons at the bottom of the screen and inside the menu for speediness 😉", quick_replies: [['Picking games', 'Picking games'], ['Prizes', 'Prizes']]
      stop_thread
    end
  end
  
  def help_prizes
    message.typing_on
    sleep 1.5
    say "💔 I split up the $25 Amazon gift card amongst the winners for the day and send them out within 24 hours."
    sleep 2
    message.typing_on
    sleep 0.5
    say "🏆 I know, poor Emma, only offering $25 a day..."
    sleep 2
    message.typing_on
    sleep 1.5
    say "But hey, I'm growing super fast, thanks to you 😍"
    sleep 1
    message.typing_on
    sleep 1
    say "So the quicker we get put on the map, the more money & prizes I'll be able to offer 🙌", quick_replies: [["Got it!", "Got it!"]]
    stop_thread
  end

  def help_with_spread
    message.typing_on
    sleep 0.5
    say "🔢 When you see a number like (-3.5) or (+3.5), that's called the spread."
    sleep 1.5
    message.typing_on
    sleep 1
    say "➖ A negative number means the favorite needs to win by MORE than the number to cover the spread."
    sleep 2
    message.typing_on
    sleep 1
    say "➕ A positive number means the underdog needs to keep it close and either win or not lose by MORE than the number.", quick_replies: [['Got it!', 'Got it!']]
    stop_thread
  end

  def help_picking_games
    message.typing_on
    sleep 0.5
    say "☝️  Make your picks against the spread."
    sleep 1
    message.typing_on
    sleep 1.5
    say "👉 You can always skip games, they'll be there waiting for you until gametime."
    sleep 1
    message.typing_on
    sleep 1.5
    say "🤞 Hit a streak of 4 and win your share of a $25 Amazon gift card!", quick_replies: [['Spread?', 'Spread?'], ['Prizes', 'Prizes'], ['Got it!', 'Got it!']]
    stop_thread
  end
end