def listen_for_challenges
  stop_thread and return if message.text.nil?
  keywords = ['battles', 'challenges', 'battle', 'challenge', 'bet', 'bets', 'survivor', 'tournament', 'tournaments', 'live']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, to: :handle_show_challenges if matched.any?
end

def listen_for_challenges_postback
  bind 'CHALLENGES' do
    handle_show_challenges
  end
end