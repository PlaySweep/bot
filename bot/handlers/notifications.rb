module Commands
  def handle_manage_notifications
    @api = Api.new
    @api.find_or_create('users', user.id)
    case message.quick_reply
    when 'NEW GAMES'
      say "New games on or off?", quick_replies: [["On", "New games On"], ["Off", "New games Off"]]
      next_command :handle_notification_change
    when 'REMINDERS'
      say "Reminder on or off?", quick_replies: [["On", "Reminders On"], ["Off", "Reminders Off"]]
      next_command :handle_notification_change
    when 'GAME RECAPS'
      say "Game recaps on or off?", quick_replies: [["On", "Recaps On"], ["Off", "Recaps Off"]]
      next_command :handle_notification_change
    when 'TURN OFF EVERYTHING'
      set_notification_settings(user.id, :reminders, false)
      set_notification_settings(user.id, :new_games, false)
      set_notification_settings(user.id, :recaps, false)
      say "Ok, I won't bug you with notifications anymore 👍", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'NEVERMIND'
      say "Ok, nevermind."
      stop_thread
    else
      say "Ok, nevermind."
      stop_thread
    end
  end

  def handle_notification_change
    @api = Api.new
    @api.find_or_create('users', user.id)    
    case message.quick_reply
    when 'New games On'
      set_notification_settings(user.id, :new_games, true)
      say "I turned new games on", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'New games Off'
      set_notification_settings(user.id, :new_games, off)
      say "I turned new games off", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'Reminders On'
      set_notification_settings(user.id, :reminders, true)
      say "I turned your reminders on", quick_replies: [["Select picks", "Select picks"]]
      stop_thread
    when 'Reminders Off'
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
    end
  end
end