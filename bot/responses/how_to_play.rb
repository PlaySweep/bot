def general_how_to_play
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  if sweepy.current_team
    how_to_play_copy = sweepy.copies.find { |copy| copy.category == "How To Play" }
    interpolated_how_to_play_copy = how_to_play_copy.message % { team_abbreviation: sweepy.current_team.abbreviation }
    quick_replies = [{content_type: :text, title: "Play now", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Status", payload: "STATUS"}]
    say interpolated_how_to_play_copy, quick_replies: quick_replies
  else
    national_how_to_play_copy = sweepy.copies.find { |copy| copy.category == "National How To Play" }
    quick_replies = [{content_type: :text, title: "Play now", image_url: sweepy.current_team.image, payload: "PLAY"}, {content_type: :text, title: "Status", payload: "STATUS"}]
    say national_how_to_play_copy.message, quick_replies: quick_replies
  end
  stop_thread
  message.typing_off
end