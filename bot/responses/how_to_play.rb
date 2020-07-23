def general_how_to_play
  
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  if sweepy.confirmed
    puts "Sweepy #{sweepy.inspect}"
    how_to_play_copy = sweepy.copies.find { |copy| copy.category == "How To Play" }
    if sweepy.current_team_is_default
      interpolated_how_to_play_copy = how_to_play_copy.message % { team_abbreviation: sweepy.current_team.account }
    else
      interpolated_how_to_play_copy = how_to_play_copy.message % { team_abbreviation: sweepy.current_team.abbreviation }
    end
    quick_replies = [{content_type: :text, title: "Play now", image_url: sweepy.current_team.image, payload: "PLAY"}]
    say interpolated_how_to_play_copy, quick_replies: quick_replies
  else
    how_to_play_copy = sweepy.copies.find { |copy| copy.category == "How To Play" }
    if sweepy.current_team_is_default
      interpolated_how_to_play_copy = how_to_play_copy.message % { team_abbreviation: sweepy.current_team.account }
    else
      interpolated_how_to_play_copy = how_to_play_copy.message % { team_abbreviation: sweepy.current_team.abbreviation }
    end
    quick_replies = [{content_type: :text, title: "Sign up now!", payload: "PLAY READY"}]
    say interpolated_how_to_play_copy, quick_replies: quick_replies
  end
  stop_thread
end