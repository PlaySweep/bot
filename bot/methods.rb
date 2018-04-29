def update_referrer referral_id
  @api = Api.new
  @api.fetch_user(referral_id)
  new_referral_count = @api.user.data.referral_count += 1
  new_sweep_coin_balance = @api.user.data.sweep_coins += 10
  params = { :user => { :referral_count => new_referral_count, :sweep_coins => new_sweep_coin_balance } }
  @api.update("users", referral_id, params)
  $tracker.track(@api.user.id, 'User Made Referral')
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
      title: 'Deny 👎',
      payload: "DENY CHALLENGE REQUEST #{@api.challenge.id}"
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
  @api.fetch_user(user.id)
  $tracker.track(@api.user.id, 'User Referred')
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
    }
  ]
  message_options = {
    messaging_type: "UPDATE",
    recipient: { id: referral_id },
    message: {
      text: "Your friend #{@api.user.first_name} #{@api.user.last_name} just signed up!",
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
  when 'pick changed'
    params = { :user => { :pick_changed => option } }
    puts "Pick changed"
  end
  @api.update("users", id, params)
end

def use_lifeline
  @api = Api.new
  @api.fetch_user(user.id)
  balance = @api.user.data.sweep_coins
  current_streak = @api.user.current_streak
  previous_streak = @api.user.previous_streak
  params = { :user => { :sweep_coins => balance -= 30, :current_streak => previous_streak, :previous_streak => current_streak } }
  @api.update('users', user.id, params)
  puts "💸"
end

def set_notification_settings id, type, action
  @api = Api.new
  params = { :user => { type => action } }
  @api.update("users", id, params)
  puts "Set notifications 👍" 
end