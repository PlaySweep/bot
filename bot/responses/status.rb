def fetch_status
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  # contest_size = sweepy.latest_stats.size == 1 ? "contest" : "#{sweepy.latest_stats.size} contests"
  # if sweepy.current_account_leaderboard
  #   quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Share", payload: "SHARE"}]
  # else
  #   quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Share", payload: "SHARE"}]
  # end
  # if sweepy.latest_stats.size >= 1
  #   say "You're on a current streak of #{sweepy.stats.current_pick_streak} and have gone #{sweepy.latest_stats.map(&:wins).sum}-#{sweepy.latest_stats.map(&:losses).sum} in your last #{contest_size}.", quick_replies: quick_replies
  # else
  #   say "You're just getting started, #{sweepy.first_name}! We'll begin collecting some stats for you soon...", quick_replies: quick_replies
  # end
  quick_replies = [{content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Share", payload: "SHARE"}]
  say "You're just getting started, #{sweepy.first_name}! We'll begin collecting some stats for you soon...", quick_replies: quick_replies
  stop_thread
end