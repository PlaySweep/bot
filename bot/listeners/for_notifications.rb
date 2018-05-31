def listen_for_notifications
  stop_thread and return if message.text.nil?
  keywords = ['stop', 'unsubscribe', 'quit', 'notifications', 'notification', 'alert', 'alerts']
  if keywords.any? {|keyword| keyword == message.text.downcase }
    @api = Api.new
    @api.fetch_user(user.id)
    keywords = ['stop', 'unsubscribe', 'quit', 'notifications', 'notification', 'alert', 'alerts']
    msg = message.text.split(' ').map(&:downcase)
    matched = (keywords & msg)
    new_games, reminders, recaps = @api.user.notification_settings.new_games, @api.user.notification_settings.reminders, @api.user.notification_settings.recaps
    if (!new_games && !reminders && !recaps)
      bind keywords, to: :entry_to_notifications, reply_with: {
       text: "All your notifications are turned off.\n\nWhich notification would you like to change?",
       quick_replies: ["New games", "Reminders", "Game recaps", "Nevermind"]
      } if matched.any?
    else
      bind keywords, to: :entry_to_notifications, reply_with: {
       text: "Which notification would you like to change?",
       quick_replies: ["Turn off everything", "New games", "Reminders", "Game recaps", "Nevermind"]
      } if matched.any?
    end
  end
end

def listen_for_notifications_postback
  case postback.payload
  when 'MANAGE NOTIFICATIONS'
    @api = Api.new
    @api.fetch_user(user.id)
    new_games, reminders, recaps = @api.user.notification_settings.new_games, @api.user.notification_settings.reminders, @api.user.notification_settings.recaps
    if (!new_games && !reminders && !recaps)
      bind 'MANAGE NOTIFICATIONS' do
       say "All your notifications are turned off.\n\nWhich notification would you like to change?", quick_replies: ["New games", "Reminders", "Game recaps", "Nevermind"]
       next_command :entry_to_notifications
      end
    else
      bind 'MANAGE NOTIFICATIONS' do
       say "Which notification would you like to change?", quick_replies: ["Turn off everything", "New games", "Reminders", "Game recaps", "Nevermind"]
       next_command :entry_to_notifications
      end
    end
  end
end