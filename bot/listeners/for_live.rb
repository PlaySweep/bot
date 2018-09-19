def listen_for_live
  stop_thread and return if message.quick_reply.nil?
  survivor
end

def survivor
  case message.quick_reply.split(' ')[0]
  when 'SURVIVOR'
    event_id = message.quick_reply.split(' ')[1]
    selected_id = message.quick_reply.split(' ')[2]
    contest_id = message.quick_reply.split(' ')[3]
    event = Sweep::Event.find(id: event_id)
    if (event.status == 'started' || event.status == 'finished')
      user.session[:event_name] = event.data.name
      keywords = %w[survivor]
      msg = message.quick_reply.split(' ').map(&:downcase)
      matched = (keywords & msg)
      bind keywords, all: true, to: :entry_to_too_late_for_survivor if matched.any?
    else
      pick = Sweep::Pick.create(facebook_uuid: user.id, attributes: {event_id: event_id, selected_id: selected_id})
      if pick
        say "✅ #{pick.selected.data.name}"
        url = "#{ENV['WEBVIEW_URL']}/#{user.id}/survivor_contests/#{contest_id}"
        show_button("LIVE Status 💥", "Tap below to keep up with how things are going 👇", nil, url)
        stop_thread
      else
        @sweepy = Sweep::User.find(user.id)
        say "Ahhh #{@sweepy.first_name}, you ran out of time on that pick! You've been eliminated from the #{user.session[:event_name]} 🙅."
        stop_thread
      end
    end
  end
end