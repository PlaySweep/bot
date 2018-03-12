def update_sender id
  $api.find('users', id)
  @new_user = $api.user
  referral_count = $api.user.data.referral_count
  sweep_coin_balance = $api.user.data.sweep_coins
  new_referral_count = referral_count + 1
  new_sweep_coin_balance = sweep_coin_balance + 10
  params = { :user => { :referral_count => new_referral_count, :sweep_coins => new_sweep_coin_balance } }
  response = $api.conn.patch("users/#{id}", params)
  puts "Updated referrals for #{$api.user.first_name} #{$api.fb_user.last_name}"
  $api.find('users', $api.fb_user.id)
  send_confirmation
end

def send_confirmation
  menu = [
    {
      content_type: 'text',
      title: 'Invite friends',
      payload: 'Invite friends'
    },
    {
      content_type: 'text',
      title: 'Select picks',
      payload: 'Select picks'
    }
  ]
  message_options = {
    messaging_type: "UPDATE",
    recipient: { id: $api.fb_user.id },
    message: {
      text: "Your friend #{@new_user.first_name} #{@new_user.last_name} just signed up! Your referral count is now at #{$api.user.data.referral_count}.",
      quick_replies: menu
    }
  }
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
end

def set field, id
  case field
  when 'status touched'
    params = { :user => { :status_touched => true } }
    puts "Status flow touched"
  when 'status changed'
    params = { :user => { :status_changed => false } }
    puts "Status flow changed"
  end
  $api.conn.patch("users/#{id}", params)
  $api.find_or_create('users', id)
end

def use_lifeline id
  $api.find('users', id)
  balance = $api.user.sweep_coins
  current_streak = $api.user.current_streak
  previous_streak = $api.user.previous_streak
  params = { :user => { :sweep_coins => balance -= 30, :current_streak => previous_streak, :previous_streak => current_streak } }
  $api.conn.patch("users/#{id}", params)
  $api.find_or_create('users', id)
  puts "💸"
end

def set_notification_settings type, action
  params = { :user => { type => action } }
  response = $api.conn.patch("users/#{$api.fb_user.id}", params)
  puts "#{$api.fb_user.first_name} #{$api.fb_user.last_name} set #{type} to #{action}"
end


def get_users_with_reminders
  url = "#{SWEEP_API}/api/v1/users?reminders=true" 
  response = HTTParty.get(url)
  response = JSON.parse(response.body)
  @users = response["users"]
end

def set_notified pick_id
  url = "#{SWEEP_API}/api/v1/picks/#{pick_id}/notified"
  params = { :pick => { :notified => true } }
  response = HTTParty.patch(url, query: params)
end