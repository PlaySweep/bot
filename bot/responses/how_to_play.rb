def general_how_to_play
  
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  if sweepy.confirmed
    how_to_play_copy = sweepy.copies.find { |copy| copy.category == "How To Play" }
    interpolated_how_to_play_copy = how_to_play_copy.message % { team_abbreviation: sweepy.current_team.abbreviation }
    quick_replies = [{content_type: :text, title: "Play now", image_url: sweepy.current_team.image, payload: "PLAY"}]
    say interpolated_how_to_play_copy, quick_replies: quick_replies
  else
    how_to_play_copy = sweepy.copies.find { |copy| copy.category == "How To Play" }
    interpolated_how_to_play_copy = how_to_play_copy.message % { team_abbreviation: sweepy.current_team.abbreviation }
    quick_replies = [{content_type: :text, title: "Sign up now!", payload: "PLAY READY"}]
    say interpolated_how_to_play_copy, quick_replies: quick_replies
  end
  stop_thread
end