def update_referrer referral_id
  @api = Api.new
  @api.fetch_user(referral_id)
  puts "🎉"*25
  puts "Referral 😁 😁 😁"
  message_options = {
    messaging_type: "UPDATE",
    recipient: { id: 1566539433429514 },
    message: {
      text: "Referral made by #{@api.user.full_name}"
    }
  }
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
  new_referral_count = @api.user.data.referral_count += 1
  new_sweep_coin_balance = @api.user.data.sweep_coins += 100
  params = { :user => { :referral_count => new_referral_count, :sweep_coins => new_sweep_coin_balance }, :friend_uuid => user.id }
  @api.update("users", referral_id, params)
  $tracker.track(@api.user.id, "User Made Referral")
  send_confirmation(referral_id)
end

def send_challenge_request id, params
  @api = Api.new
  @api.create('challenges', id, params)

  sender = @api.fetch_user(id)
  menu = [
    {
      content_type: 'text',
      title: 'Accept 👍',
      payload: "ACCEPT CHALLENGE REQUEST #{@api.challenge.id}"
    },
    {
      content_type: 'text',
      title: 'Decline 👎',
      payload: "DECLINE CHALLENGE REQUEST #{@api.challenge.id}"
    }
  ]

  custom_message = build_custom_message(@api.challenge)

  message_options = {
    messaging_type: "UPDATE",
    recipient: { id: params[:challenge][:friend_id] },
    message: {
      text: "#{sender.first_name} #{sender.last_name} #{custom_message}",
      quick_replies: menu
    }
  }
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
end

def send_confirmation referral_id
  @api = Api.new
  new_user = @api.fetch_user(user.id)
  referrer = @api.fetch_user(referral_id)
  $tracker.track(@api.user.id, 'User Was Referred')

  menu = [
    {
      content_type: 'text',
      title: 'Share 🎉',
      payload: 'INVITE FRIENDS'
    },
    {
      content_type: 'text',
      title: 'Select picks',
      payload: 'SELECT PICKS'
    },
    {
      content_type: 'text',
      title: 'Challenge friends',
      payload: 'CHALLENGE'
    }
  ]
  message_options = {
    messaging_type: "UPDATE",
    recipient: { id: referral_id },
    message: {
      text: "#{new_user['first_name']} #{new_user['last_name']} joined!\n\n100 Sweepcoins have been added to your wallet 💰",
      quick_replies: menu
    }
  }
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
end

def set field, id, option
  @api = Api.new
  case field
  when 'status changed'
    params = { :user => { :status_changed => option } }
    puts "Status flow changed"
  end
  @api.update("users", id, params)
end

def use_lifeline new_streak
  @api = Api.new
  @api.fetch_user(user.id)
  daily_id = @api.user.daily.id
  balance = @api.user.data.sweep_coins
  current_streak = @api.user.current_streak
  params = { :user => { :sweep_coins => balance -= 30, :current_streak => new_streak, :previous_streak => current_streak, :current_losing_streak => 0 } }
  @api.update('users', user.id, params)
  puts "💸"
  params = { :daily_statistic => { :lifeline_used => true } }
  @api.update('daily_statistics', daily_id, params, user.id)
  puts "✅"
end

def set_notification_settings id, preference, action, type=nil
  if type == :add
    @api = Api.new
    @api.fetch_user(user.id)
    category_preferences = @api.user.notification_settings.category_preferences
    category_preferences.include?("NA") ? category_preferences.delete_at(category_preferences.index("NA")) : nil
    category_preferences.push(action)
    params = { :user => { preference => category_preferences } }
    puts "Params: #{params.inspect}"
    @api.update("users", id, params)
    puts "Add #{action} preferences 👍" 
  elsif type == :remove
    @api = Api.new
    @api.fetch_user(user.id)
    category_preferences = @api.user.notification_settings.category_preferences
    category_preferences.delete_at(category_preferences.index(action))
    category_preferences.empty? ? category_preferences.push("NA") : nil
    params = { :user => { preference => category_preferences } }
    puts "Params: #{params.inspect}"
    @api.update("users", id, params)
    puts "Remove #{action} preferences 👍" 
  else
    @api = Api.new
    params = { :user => { preference => action } }
    @api.update("users", id, params)
    puts "Set notification 👍"
  end
end