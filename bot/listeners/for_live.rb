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
    if (event.status == 'started' || event.status == 'finished')
      puts "DONT MAKE THE PICK"
      say "You missed the deadline! 😡"
      keywords = %w[survivor]
      msg = message.quick_reply.split(' ').map(&:downcase)
      matched = (keywords & msg)
      bind keywords, all: true, to: :entry_to_too_late_for_survivor if matched.any?
    else
      puts "This should not run..."
      pick = Sweep::Pick.create(facebook_uuid: user.id, attributes: {event_id: event_id, selected_id: selected_id})
      if pick
        user.session[:selected_pick] = pick.selected.data.name
        keywords = %w[survivor]
        msg = message.quick_reply.split(' ').map(&:downcase)
        matched = (keywords & msg)
        bind keywords, all: true, to: :entry_to_survivor if matched.any?
      else
        keywords = %w[survivor]
        msg = message.quick_reply.split(' ').map(&:downcase)
        matched = (keywords & msg)
        bind keywords, all: true, to: :entry_to_too_late_for_survivor if matched.any?
      end
    end
  end
end