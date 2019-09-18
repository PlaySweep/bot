def general_how_to_play
  message.typing_on
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  if sweepy.roles.first
    how_to_play_copy = sweepy.copies.find { |copy| copy.category == "How To Play" }
    interpolated_how_to_play_copy = how_to_play_copy.message % { team_abbreviation: sweepy.roles.first.abbreviation }
    say interpolated_how_to_play_copy
  else
    national_how_to_play_copy = sweepy.copies.find { |copy| copy.category == "National How To Play" }
    say national_how_to_play_copy.message
  end
  stop_thread
  message.typing_off
end