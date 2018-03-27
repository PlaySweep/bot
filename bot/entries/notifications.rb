module Commands
  def manage_updates
    @api = Api.new
    @api.find_or_create('users', user.id)
    case message.text
    when 'Reminders'
      say "Reminder on or off?", quick_replies: [["On", "Reminders On"], ["Off", "Reminders Off"]]
      next_command :handle_notifications
    when 'Game recaps'
      say "Game recaps on or off?", quick_replies: [["On", "Recaps On"], ["Off", "Recaps Off"]]
      next_command :handle_notifications
    when 'Off'
      say "Turn off all notifications?", quick_replies: [["Yes", "All Off Yes"], ["Off", "All Off No"]]
      next_command :handle_notifications
    when 'Stop'
      say "Turn off all notifications?", quick_replies: [["Yes", "All Off Yes"], ["Off", "All Off No"]]
      next_command :handle_notifications
    when 'Unsubscribe'
      say "Turn off all notifications?", quick_replies: [["Yes", "All Off Yes"], ["Off", "All Off No"]]
      next_command :handle_notifications
    when "I'm good"
      say "Ok 😊", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"], ["Sweepcoins", "Sweepcoins"]]
      stop_thread
    else
      status and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_STATUS.include?(keyword) }
      dashboard and return if message.text.downcase.split(' ').any? { |keyword| KEYWORDS_FOR_DASHBOARD.include?(keyword) }
    end
  end

  def handle_notifications
    @api = Api.new
    @api.find_or_create('users', user.id)    
    case message.quick_reply
    when 'Reminders On'
      set_notification_settings(user.id, :new_games, true)
      set_notification_settings(user.id, :reminders, true)
      say "I turned your reminders on", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'Reminders Off'
      set_notification_settings(user.id, :new_games, false)
      set_notification_settings(user.id, :reminders, false)
      say "I won't bug you with reminders anymore", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'Recaps On'
      set_notification_settings(user.id, :recaps, true)
      say "I turned your recaps on", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'Recaps Off'
      set_notification_settings(user.id, :recaps, false)
      say "I won't bug you with recaps anymore", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'All Off Yes'
      set_notification_settings(user.id, :reminders, false)
      set_notification_settings(user.id, :new_games, false)
      set_notification_settings(user.id, :recaps, false)
      say "Ok, I won't bug you with notifications anymore 👍", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'All Off No'
      say "Ok, I won't touch a thing 👍", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
      stop_thread
    end
  end
end