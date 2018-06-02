module Commands
  def handle_manage_notifications
    @api = Api.new
    @api.fetch_user(user.id)
    current_preferences = @api.user.notification_settings.category_preferences
    current_preferences.each { |preference| }
    case message.quick_reply
    when 'GAME PREFERENCES'
      if current_preferences.length > 0
         say "You're currently receiving alerts for 👇"
         list_preferences = ""
         current_preferences.each_with_index do |preference, index|
          if (index == current_preferences.length - 1)
            list_preferences += "🔔 #{preference}"
          else
            list_preferences += "🔔 #{preference}\n"
          end
         end
        say "#{list_preferences}", quick_replies: ['Add more', 'Remove']
        next_command :handle_preference_change
      else
        say "Add custom sport notifications 👍\n\nLike NFL, NBA, ..."
        next_command :handle_preferences
      end
    when 'GAME RECAPS'
      say "Game recaps on or off?", quick_replies: [["On", "RECAPS ON"], ["Off", "RECAPS OFF"]]
      next_command :handle_notification_change
    when 'TURN OFF EVERYTHING'
      @api = Api.new
      @api.fetch_user(user.id)
      params = { :user => { :active => false } }
      @api.update("users", user.id, params)
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
        @api = Api.new
        @api.fetch_user(user.id)
        params = { :user => { :active => false } }
        @api.update("users", user.id, params)
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

  def handle_preferences  
    @api = Api.new
    @api.fetch_user(user.id)
    current_preferences = @api.user.notification_settings.category_preferences
    newly_added_preferences = [] 
    categories = @api.fetch_sports.map(&:downcase)
    preferences = message.text.split(',')
    if (categories & preferences)
      say "Found #{preferences}!"
      stop_thread
    end
  end

  def handle_preference_change 
    case message.quick_reply
    when 'ADD MORE'
      say "Type more..."
      next_command :handle_add_preferences
    when 'REMOVE'
      say "Type the ones you want to remove..."
      next_command :handle_remove_preferences
    end
  end

  def handle_add_preferences
    @api = Api.new
    @api.fetch_user(user.id)
    current_preferences = @api.user.notification_settings.category_preferences
    preferences_to_add = [] 
    categories = @api.fetch_sports.map(&:downcase)
    preferences = message.text.split(',')
    if (categories & preferences).any?
      say "Adding #{preferences}!"
      stop_thread
    end
  end

  def handle_remove_preferences
    @api = Api.new
    @api.fetch_user(user.id)
    current_preferences = @api.user.notification_settings.category_preferences
    preferences_to_remove = [] 
    categories = @api.fetch_sports.map(&:downcase)
    preferences = message.text.split(',')
    if (categories & preferences).any?
      say "Removing #{preferences}!"
      stop_thread
    end
  end
end