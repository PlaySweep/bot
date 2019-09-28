require 'possessive'

def fetch_status
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  contest_size = sweepy.latest_stats.size == 1 ? "contest" : "#{sweepy.latest_stats.size} contests"
  say "You're on a current streak of #{sweepy.stats.current_pick_streak} and have gone #{sweepy.latest_stats.map(&:wins).sum}-#{sweepy.latest_stats.map(&:losses).sum} in your last #{contest_size}."
  fetch_picks
  stop_thread
  message.typing_off
end