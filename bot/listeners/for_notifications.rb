def listen_for_notifications
  stop_thread and return if message.text.nil?
  keywords = ['stop', 'unsubscribe', 'quit', 'notifications', 'notification', 'alert', 'alerts']
  if keywords.any? {|keyword| keyword == message.text.downcase }
    @api = Api.new
    @api.fetch_user(user.id)
    keywords = ['stop', 'unsubscribe', 'quit', 'notifications', 'notification', 'alert', 'alerts']
    msg = message.text.split(' ').map(&:downcase)
    matched = (keywords & msg)
    recaps = @api.user.notification_settings.recaps
    category_preferences = @api.user.notification_settings.category_preferences
    if (!recaps && category_preferences.include?("NA"))
      bind keywords, to: :entry_to_notifications, reply_with: {
       text: "All your notifications are turned off.\n\nWhich notification would you like to change?",
       quick_replies: ["Game preferences", "Game recaps", "Nevermind"]
      } if matched.any?
    else
      bind keywords, to: :entry_to_notifications, reply_with: {
       text: "Which notification would you like to change?",
       quick_replies: ["Turn off everything", "Game preferences", "Game recaps", "Nevermind"]
      } if matched.any?
    end
  end
end

def listen_for_notifications_postback
  case postback.payload
  when 'MANAGE NOTIFICATIONS'
    @api = Api.new
    @api.fetch_user(user.id)
    recaps = @api.user.notification_settings.recaps
    category_preferences = @api.user.notification_settings.category_preferences
    if (!recaps && category_preferences.include?("NA"))
      bind 'MANAGE NOTIFICATIONS' do
       say "All your notifications are turned off.\n\nWhich notification would you like to change?", quick_replies: ["Game preferences", "Game recaps", "Nevermind"]
       next_command :entry_to_notifications
      end
    else
      bind 'MANAGE NOTIFICATIONS' do
       say "Which notification would you like to change?", quick_replies: ["Turn off everything", "Game preferences", "Game recaps", "Nevermind"]
       next_command :entry_to_notifications
      end
    end
  end
end