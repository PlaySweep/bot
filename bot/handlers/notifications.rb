module Commands
  def handle_manage_notifications
    @api = Api.new
    @api.fetch_user(user.id)
    active_categories = @api.fetch_sports(active: true)
    case message.quick_reply
    when 'YES'
      say "Which sport updates do you want to change?", quick_replies: active_categories
      next_command :handle_category_selection
    when 'GAME PREFERENCES'
      say "Which sport updates do you want to change?", quick_replies: active_categories
      next_command :handle_category_selection
    when 'GAME RECAPS'
      @api.user.notification_settings.recaps ? currently_on = true : currently_on = false
      if currently_on
        say "Currently on ⏰\n\nWhen turned off, I won't send you morning recaps of your previous day results 😊\n\nTurn recaps off?", quick_replies: [["Turn off", "RECAPS OFF"], ["Nevermind", "NEVERMIND"]]
        next_command :handle_notification_change
      else
        say "Currently off 🛑\n\nWhen turned on, I'll send you morning recaps of your previous day results 😊\n\nTurn recaps on?", quick_replies: [["Turn on", "RECAPS ON"], ["Nevermind", "NEVERMIND"]]
        next_command :handle_notification_change
      end
    when 'TURN OFF EVERYTHING'
      @api = Api.new
      @api.fetch_user(user.id)
      params = { :user => { :active => false } }
      @api.update("users", user.id, params)
      set_notification_settings(user.id, :recaps, false)
      set_notification_settings(user.id, :category_preferences, ["NA"])
      say "Ok, I won't bug you with notifications anymore 👍", quick_replies: ["Select picks"]
      $tracker.track(user.id, 'Notification Changed', {'type' => 'All Off'})
      stop_thread
    when 'NEVERMIND'
      say "Ok, you're all set then 👍", quick_replies: ["Make picks", "Status"]
      stop_thread
    else
      if (message.text.downcase.split(' ') & ['everything', 'stop', 'quit', 'unsubscribe'].map(&:squeeze)).any?
        @api = Api.new
        @api.fetch_user(user.id)
        params = { :user => { :active => false } }
        @api.update("users", user.id, params)
        set_notification_settings(user.id, :recaps, false)
        set_notification_settings(user.id, :category_preferences, ["NA"])
        say "Ok, I won't bug you with notifications anymore 👍", quick_replies: ["Select picks"]
        $tracker.track(user.id, 'Notification Changed', {'type' => 'All Off'})
        stop_thread
      else
        say "Ok, you're all set then 👍", quick_replies: ["Make picks", "Status"]
        stop_thread
      end
    end
  end

  def handle_category_selection
    @api = Api.new
    active_categories = @api.fetch_sports(active: true)
    sport_reply = message.quick_reply
    if active_categories.map(&:upcase).include?(sport_reply)
      sport = message.text
      @api.fetch_user(user.id)
      active_preferences = @api.user.notification_settings.category_preferences
      active_preferences.include?(sport) ? currently_on = true : currently_on = false
      if currently_on
        say "Currently on ⏰\n\nWhen turned off, I'll stop sending reminders for new games and results when the match closes 😊\n\nTurn #{sport} off?", quick_replies: [["Turn off", "#{message.quick_reply} OFF"], ["Nevermind", "NEVERMIND"]]
        next_command :handle_notification_change
      else
        say "Currently off 🛑\n\nWhen turned on, I'll let you know when new games have been added and your results when the match closes 😊\n\nTurn #{sport} on?", quick_replies: [["Turn on", "#{message.quick_reply} ON"], ["Nevermind", "NEVERMIND"]]
        next_command :handle_notification_change
      end
    end
  end

  def handle_notification_change 
    @api = Api.new
    active_categories = @api.fetch_sports(active: true) 
    if message.quick_reply.split(' ').length == 3
      sport = message.quick_reply.split(' ')[0..1].join(' ')
    elsif message.quick_reply.split(' ').length == 2
      sport = message.quick_reply.split(' ')[0]
    end
    case message.quick_reply
    when 'RECAPS ON'
      set_notification_settings(user.id, :recaps, true)
      say "Cool, I turned your daily recaps on 👍", quick_replies: ["Select picks"]
      $tracker.track(user.id, 'Notification Changed', {'type' => 'Recaps On'})
      stop_thread
    when 'RECAPS OFF'
      set_notification_settings(user.id, :recaps, false)
      say "Ok, I won't bug you with daily recaps anymore 👍", quick_replies: ["Select picks"]
      $tracker.track(user.id, 'Notification Changed', {'type' => 'Recaps Off'})
      stop_thread
    when "#{sport} ON"
      sport.split(' ').length > 1 ? sport_param = sport.split(' ').map(&:capitalize).join(' ') : sport_param = sport
      set_notification_settings(user.id, :category_preferences, "#{sport_param}", :add)
      say "Ok, I turned on notifications for #{sport_param} 👍"
      short_wait(:message)
      say "Want to customize any other categories?", quick_replies: ["Yes", ["No thanks", "NEVERMIND"]]
      $tracker.track(user.id, 'Notification Changed', {'type' => "#{sport_param} On"})
      next_command :handle_manage_notifications
    when "#{sport} OFF"
      sport.split(' ').length > 1 ? sport_param = sport.split(' ').map(&:capitalize).join(' ') : sport_param = sport
      set_notification_settings(user.id, :category_preferences, "#{sport_param}", :remove)
      say "Ok, I turned off notifications for #{sport_param} 👍"
      short_wait(:message)
      say "Want to customize any other categories?", quick_replies: ["Yes", ["No thanks", "NEVERMIND"]]
      $tracker.track(user.id, 'Notification Changed', {'type' => "#{sport_param} Off"})
      next_command :handle_manage_notifications
    when "NEVERMIND"
      say "Ok, you're all set then 👍", quick_replies: ["Make picks", "Status"]
      stop_thread
    else
      say "Sorry, I didn't register that..."
      stop_thread
    end
  end
end