def fetch_leaderboard
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  # if sweepy.current_team_leaderboard
  #   quick_replies = [{ content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY" }, { content_type: :text, title: "#{sweepy.current_team.abbreviation} Leaderboard", payload: "OWNER LEADERBOARD" }, { content_type: :text, title: "Share", payload: "SHARE" }]
  # else
  #   quick_replies = [{ content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY" }, { content_type: :text, title: "Share", payload: "SHARE" }]
  # end
  # quick_replies = [{ content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY" }, { content_type: :text, title: "Share", payload: "SHARE" }]
  # if sweepy.leaderboard.account
  #   if sweepy.leaderboard.account.score.to_i <= 0
  #     say "You're just getting started with the #{sweepy.leaderboard.account.name}, come back once you've started earning some points!", quick_replies: quick_replies
  #   else
  #     say "You're currently ranked #{sweepy.leaderboard.account.rank}#{sweepy.leaderboard.account.ordinal_position} with #{sweepy.leaderboard.account.score} points in the #{sweepy.leaderboard.account.name}.", quick_replies: quick_replies
  #   end
  # end
  stop_thread
end

def fetch_owner_leaderboard
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  quick_replies = [{ content_type: :text, title: "Play again", image_url: sweepy.current_team.image, payload: "PLAY" }, { content_type: :text, title: "Share", payload: "SHARE" }]
  say "You're currently ranked #{sweepy.leaderboard.owner.rank}#{sweepy.leaderboard.owner.ordinal_position} with #{sweepy.leaderboard.owner.score} points in the #{sweepy.current_team.abbreviation} points challenge.", quick_replies: quick_replies
  stop_thread
end