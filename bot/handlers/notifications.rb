module Commands
  def handle_manage_notifications
    case message.quick_reply
    when 'NEW GAMES'
      say "New games on or off?", quick_replies: [["On", "NEW GAMES ON"], ["Off", "NEW GAMES OFF"]]
      next_command :handle_notification_change
    when 'REMINDERS'
      say "Reminder on or off?", quick_replies: [["On", "REMINDERS ON"], ["Off", "REMINDERS OFF"]]
      next_command :handle_notification_change
    when 'GAME RECAPS'
      say "Game recaps on or off?", quick_replies: [["On", "RECAPS ON"], ["Off", "RECAPS OFF"]]
      next_command :handle_notification_change
    when 'TURN OFF EVERYTHING'
      set_notification_settings(user.id, :reminders, false)
      set_notification_settings(user.id, :new_games, false)
      set_notification_settings(user.id, :recaps, false)
      say "Ok, I won't bug you with notifications anymore 👍", quick_replies: ["Select picks"]
      $tracker.track(user.id, 'Notification Changed', {'type' => 'All Off'})
      stop_thread
    when 'NEVERMIND'
      say "Ok, nevermind."
      stop_thread
    else
      if (message.text.downcase.split(' ') & ['everything', 'stop', 'quit', 'unsubscribe'].map(&:squeeze)).any?
        set_notification_settings(user.id, :reminders, false)
        set_notification_settings(user.id, :new_games, false)
        set_notification_settings(user.id, :recaps, false)
        say "Ok, I won't bug you with notifications anymore 👍", quick_replies: ["Select picks"]
        $tracker.track(user.id, 'Notification Changed', {'type' => 'All Off'})
        stop_thread
      else
        say "Ok, nevermind."
        stop_thread
      end
    end
  end

  def handle_notification_change   
    case message.quick_reply
    when 'NEW GAMES ON'
      set_notification_settings(user.id, :new_games, true)
      say "I turned new games on", quick_replies: ["Select picks"]
      $tracker.track(user.id, 'Notification Changed', {'type' => 'New Games On'})
      stop_thread
    when 'NEW GAMES OFF'
      set_notification_settings(user.id, :new_games, false)
      say "I turned new games off", quick_replies: ["Select picks"]
      $tracker.track(user.id, 'Notification Changed', {'type' => 'New Games Off'})
      stop_thread
    when 'REMINDERS ON'
      set_notification_settings(user.id, :reminders, true)
      say "I turned your reminders on", quick_replies: ["Select picks"]
      $tracker.track(user.id, 'Notification Changed', {'type' => 'Reminders On'})
      stop_thread
    when 'REMINDERS OFF'
      set_notification_settings(user.id, :reminders, false)
      say "I won't bug you with reminders anymore", quick_replies: ["Select picks"]
      $tracker.track(user.id, 'Notification Changed', {'type' => 'Reminders Off'})
      stop_thread
    when 'RECAPS ON'
      set_notification_settings(user.id, :recaps, true)
      say "I turned your recaps on", quick_replies: ["Select picks"]
      $tracker.track(user.id, 'Notification Changed', {'type' => 'Recaps On'})
      stop_thread
    when 'RECAPS OFF'
      set_notification_settings(user.id, :recaps, false)
      say "I won't bug you with recaps anymore", quick_replies: ["Select picks"]
      $tracker.track(user.id, 'Notification Changed', {'type' => 'Recaps Off'})
      stop_thread
    end
  end
end