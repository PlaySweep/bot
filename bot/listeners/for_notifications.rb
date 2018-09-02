def listen_for_notifications
  stop_thread and return if message.text.nil?
  keywords = ['notifications', 'notification', 'alert', 'alerts', 'preferences', 'manage', 'preference', 'texts', 'message', 'messages']
  msg = message.text.split(' ').map(&:downcase)
  matched = (keywords & msg)
  bind keywords, to: :handle_show_preferences if matched.any?
end

def listen_for_notifications_postback
  bind 'PREFERENCES' do
    handle_show_preferences
  end
end