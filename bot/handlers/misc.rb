def handle_blow_steam
  case message.quick_reply
  when "Vent"
    say "UGHGHGHGHHH I DISLIKE SPORTS VERY MUCH!! 👿!!🙄!!!😡!!!👿!!😡!!!🙄!!"
    sleep 1
    message.typing_on
    sleep 1
    say "...Ok your turn, and then we can get back to work 👍 (staying positive, staying positive)"
    next_command :handle_let_it_out
  when "I'm ok..."
    say "Well look at you, channeling your inner calm. So proud of you 😊"
    sleep 1
    message.typing_on
    sleep 1
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
  when 'Tell me something'
    say TELL_ME_SOMETHING.sample, quick_replies: ["Select picks", "Status"]
    stop_thread
  else
    redirect(:catch)
    stop_thread
  end
  stop_thread
end