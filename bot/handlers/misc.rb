module Commands
  def handle_blow_steam
    case message.quick_reply
    when "VENT"
      say "UGHGHGHGHHH 👿!!🙄!!!😡!!!👿!!😡!!!🙄!!"
      short_wait(:message)
      say "...Ok your turn, and then we can get back to work 👍 (staying positive, staying positive)"
      next_command :handle_let_it_out
    when "I'M OK"
      say "Well look at you, channeling your inner calm. So proud of you 😊"
      short_wait(:message)
      say "Alright, let's go get us a win!", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
      stop_thread
    else
      redirect(:blow_steam)
      stop_thread
    end
    stop_thread
  end

  def handle_let_it_out
    say "Alright, alright...better now? Good. Let's go get us a win!", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
    stop_thread
  end

  def handle_fun
    case message.quick_reply
    when 'TELL ME SOMETHING'
      say TELL_ME_SOMETHING.sample, quick_replies: ["Select picks", "Status"]
      stop_thread
    else
      redirect(:catch)
      stop_thread
    end
    stop_thread
  end
end