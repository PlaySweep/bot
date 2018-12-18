module Commands
  def handle_show_sports
    options = ["Just tap below if you're looking to make picks 👇", "Time to show off your prediction skills 🏆!"]
    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/event?loader"
    show_button("PICK EM 🎉", options.sample, nil, url)
    stop_thread
  end

  def handle_no_sports_available
    options = [
      "Time is a flat circle and we're back here again. Check back later for more games 🕛",
      "If we're using our made-up names, I'm Spider-Man. You can be Dr. Strange. I'll message when I have more for you, Dr. Strange 🕷",
      "Looks like you're stuck in the sunken place, no more games left to be picked.",
      "You're done with picks for now, but don't ever leave me. Cause I'd find you...😜",
      "No more games to pick here, maybe your mom has some meatloaf?",
      "Nothing else available, gonna grab my wolfpack and hit the desert in Vegas",
      "Our work is done here, but imagine what a little Vibranium could do...",
      "If you ever take me to California, I hope you mean Coachella. All done for now.",
      "You're all caught up across the board. I'll have more games soon.",
      "No more games to pick here, now is your time to think about how you'd take down a Demigorgon 🤔",
      "No more games for now, I promise I won’t keep you waiting as long as the post office 📫",
      "You’ve made your picks. Now go make peace with that printer upstairs that never works 🙄",
      "All finished...what? Expecting another joke or something? 😝",
      "No more games yet....and no, you can’t ask me to help you carry your couch when you move. I'm a bot. 🤖"
    ]

    url = "#{ENV['WEBVIEW_URL']}/#{user.id}/dashboard?loader"
    show_button("See Picks 👀", options.sample, nil, url)
    stop_thread
  end
end