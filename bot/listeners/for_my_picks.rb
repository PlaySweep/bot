# def listen_for_my_picks
#  keywords = ['my picks', 'current picks', 'upcoming picks']
#  msg = message.text.split(' ').permutation(2).to_a.map { |m| m.join(' ').downcase }
#  matched = (keywords & msg)
#  bind 'current picks', 'my picks', 'upcoming picks', to: :entry_to_my_picks if matched.any?
# end

# def listen_for_my_picks_postback
#   bind 'MY PICKS', to: :entry_to_my_picks_postback
# end