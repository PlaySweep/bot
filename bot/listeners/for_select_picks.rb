def listen_for_select_picks
  single_match || double_match
end

def listen_for_select_picks_postback
  bind 'SELECT PICKS' do
    if matchups_available?
      sports = @matchups.map(&:sport).uniq
      say PICKS.sample, quick_replies: sports
      next_command :entry_to_show_sports
    else
      say "Nothing left to pick from. Check back later.", quick_replies: ["Status", "Challenges"]
      stop_thread
    end
  end
end

def single_match
  keywords = ['games', 'matchups', 'nba', 'basketball', 'football', 'ncaab']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  if matched.any?
    if matchups_available?
      data = {}
      sports = @matchups.map(&:sport).uniq
      data[:text] = PICKS.sample
      data[:quick_replies] = sports
      bind keywords, all: true, to: :entry_to_show_sports, reply_with: data
    else
      bind keywords, all: true, to: :entry_to_no_sports_available
    end
  end
end

def double_match
  keywords = ['start sweeping', 'make picks', 'select picks', 'more sports', 'college basketball']
  msg = message.text.split(' ').permutation(2).to_a.map { |m| m.join(' ').downcase }
  matched = (keywords & msg)
  if matched.any?
    if matchups_available?
      data = {}
      sports = @matchups.map(&:sport).uniq
      data[:text] = PICKS.sample
      data[:quick_replies] = sports
      bind keywords, all: true, to: :entry_to_show_sports, reply_with: data
    else
      bind keywords, all: true, to: :entry_to_no_sports_available
    end
  end
end

def matchups_available?
  @api = Api.new
  @api.fetch_user(user.id)
  @matchups = @api.fetch_all('matchups', user.id)
  if (@matchups.nil? || @matchups.empty?)
    return false
  else
    return true
  end
end