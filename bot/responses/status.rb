require 'possessive'

def fetch_status
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  contest_size = sweepy.latest_stats.size == 1 ? "contest" : "#{sweepy.latest_stats.size} contests"
  if sweepy.latest_stats.size >= 1
    say "You're on a current streak of #{sweepy.stats.current_pick_streak} and have gone #{sweepy.latest_stats.map(&:wins).sum}-#{sweepy.latest_stats.map(&:losses).sum} in your last #{contest_size}."
  else
    say "You're just getting started, #{sweepy.first_name}! Check back once you begin collecting some stats."
  end
  fetch_picks
  stop_thread
  message.typing_off
end