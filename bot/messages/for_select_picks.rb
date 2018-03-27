def listen_for_select_picks
  single_words || double_words
end

def single_words
  keywords = ['games', 'matchups', 'nba', 'basketball', 'football', 'ncaab']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, all: true, to: :entry_to_show_sports, reply_with: {
    text: PICKS.sample,
    quick_replies: [['NCAAB', 'NCAAB'], ['NBA', 'NBA'], ['MLB', 'MLB'], ['NHL', 'NHL']]
  } if matched.any?
end

def double_words
  keywords = ['start sweeping', 'make picks', 'select picks', 'more sports', 'college basketball']
  msg = message.text.split(' ').permutation(2).to_a.map { |m| m.join(' ').downcase }
  matched = (keywords & msg)
  bind keywords, all: true, to: :entry_to_show_sports, reply_with: {
    text: PICKS.sample,
    quick_replies: [['NCAAB', 'NCAAB'], ['NBA', 'NBA'], ['MLB', 'MLB'], ['NHL', 'NHL']]
  } if matched.any?
end