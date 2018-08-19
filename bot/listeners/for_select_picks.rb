def listen_for_select_picks
  stop_thread and return if message.text.nil?
  (single_match || double_match)
end

def listen_for_select_picks_postback
  bind 'SELECT PICKS' do
    if matchups_available?
      handle_show_sports
    else
      handle_no_sports_available
    end
  end
end

def single_match
  keywords = ['games', 'pick', 'picks', 'bet', 'bets', 'matchups', 'nba', 'hockey', 'baseball', 'basketball', 'football']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  if matchups_available?
    bind keywords, all: true, to: :handle_show_sports if matched.any?
  else
    bind keywords, all: true, to: :handle_no_sports_available if matched.any?
  end
end

def double_match
  keywords = ['start sweeping', 'more sports']
  msg = message.text.split(' ').permutation(2).to_a.map { |m| m.join(' ').downcase }
  matched = (keywords & msg)
  if matchups_available?
    bind keywords, all: true, to: :handle_show_sports if matched.any?
  else
    bind keywords, all: true, to: :handle_no_sports_available if matched.any?
  end
end

def matchups_available?
  @events = Sweep::Event.all(facebook_uuid: user.id)
  (@events.nil? || @events.empty?) ? false : true
end