module Commands
  def handle_blow_steam
    say ANGRY.sample, quick_replies: ["Select picks", "Status"]
    stop_thread
  end

  def handle_fun
    say FUN.sample, quick_replies: ["Select picks", "Status"]
    stop_thread
  end

  def handle_prizing
    say "It takes me around 24-48 hours to send out Amazon gift cards 💰...\n\nIf it's been any longer than that, I'll send your feedback to the humans that made me and we can get you taken care of 😊", quick_replies: ['Send feedback', 'Select picks', 'Status']
    stop_thread
  end
end