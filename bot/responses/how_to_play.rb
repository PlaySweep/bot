def show_how_to_play
  sweepy = Sweep::User.find(facebook_uuid: user.id)
  say "A little refresher on how to play: \n\n1. I’ll send you 3 questions every day the #{sweepy.roles.first.team_name} are on the field 🙌\n2. Guess the outcome of all 3 questions right and earn a 'Sweep' 💥\n3. A Sweep enters you into a raffle every single day to win prizes 🎟\n4. Get notified when you win 🎉"
  stop_thread
end