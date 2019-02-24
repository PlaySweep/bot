def list_of_commands
  say "There’s a lot you can say - for example: \n\nJust type any of these commands and you’ll see for yourself..."
  invite_friends = "- Type 'Invite Friends' to invite friends (duh 😜)"
  status = "- Type 'Status' to see your answers"
  questions = "- Type 'Questions' to see what else is available for you to select"
  prizes = "- Type 'Prizes' to see what you have the opportunity to win"
  how_to_play = "- Type 'How do I play?' to be reminded how the game works"
  say "#{invite_friends}\n#{status}\n#{questions}\n#{prizes}\n#{how_to_play}"
  stop_thread
end