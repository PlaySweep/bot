def show_prizes
  @sweepy = Sweep::User.find(facebook_uuid: user.id)
  say "Prizes change every single day depending on the contest, but the prizes that are available are primarily game tickets and merchandise ⚾️"
  stop_thread
end