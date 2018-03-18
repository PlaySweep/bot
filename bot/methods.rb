def update_sender current_user_id, referral_id
  @api = Api.new
  @api.find('users', referral_id)
  referral_count = @api.user.data.referral_count
  sweep_coin_balance = @api.user.data.sweep_coins
  new_referral_count = referral_count += 1
  new_sweep_coin_balance = sweep_coin_balance += 10
  params = { :user => { :referral_count => new_referral_count, :sweep_coins => new_sweep_coin_balance } }
  response = @api.conn.patch("users/#{referral_id}", params)
  send_confirmation
end

def send_confirmation current_user_id, referral_id
  @api = Api.new
  @api.find('users', referral_id)
  menu = [
    {
      content_type: 'text',
      title: '🎉 Share',
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
    recipient: { id: current_user_id },
    message: {
      text: "Your friend #{@api.user.first_name} #{@api.user.last_name} just signed up!",
      quick_replies: menu
    }
  }
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
end

def set field, id
  @api = Api.new
  case field
  when 'status touched'
    params = { :user => { :status_touched => true } }
    puts "Status flow touched"
  when 'status changed'
    params = { :user => { :status_changed => false } }
    puts "Status flow changed"
  when 'store touched'
    params = { :user => { :store_touched => true } }
    puts "Store flow changed"
  end
  @api.conn.patch("users/#{id}", params)
  @api.find_or_create('users', id)
end

def use_lifeline id
  @api = Api.new
  @api.find('users', id)
  balance = @api.user.data.sweep_coins
  current_streak = @api.user.current_streak
  previous_streak = @api.user.previous_streak
  params = { :user => { :sweep_coins => balance -= 30, :current_streak => previous_streak, :previous_streak => current_streak } }
  @api.conn.patch("users/#{id}", params)
  @api.find_or_create('users', id)
  puts "💸"
end

def set_notification_settings id, type, action
  @api = Api.new
  params = { :user => { type => action } }
  response = @api.conn.patch("users/#{id}", params)
  puts "Set notifications 👍" if response.status == 200
end