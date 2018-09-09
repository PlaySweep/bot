def listen_for_live
  stop_thread and return if message.quick_reply.nil?
  survivor
end

def survivor
  case message.quick_reply.split(' ')[0]
  when 'SURVIVOR'
    event_id = message.quick_reply.split(' ')[1]
    selected_id = message.quick_reply.split(' ')[2]
    event = Sweep::Event.find(id: event_id)
    puts "⏳" * 10
    puts "#{event.status}"
    puts "⏳" * 10
    if (event.status == 'started' || event.status == 'finished')
      puts "DONT MAKE THE PICK"
      say "You missed the deadline! 😡"
      stop_thread and return
    else
      puts "This should not run..."
      pick = Sweep::Pick.create(facebook_uuid: user.id, attributes: {event_id: event_id, selected_id: selected_id})
      if pick
        url = "#{ENV['WEBVIEW_URL']}/#{user.id}/contests"
        show_button("Tournament Status", "✅ #{pick.selected.data.name}", nil, url)
        stop_thread and return
      else
        say "You missed the deadline! 😡"
        stop_thread and return
      end
    end
  end
end