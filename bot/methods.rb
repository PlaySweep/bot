def update_sender id
  $api.find('users', id)
  @new_user = $api.user
  referral_count = $api.user.data.referral_count
  new_referral_count = referral_count + 1
  params = { :user => { :referral_count => new_referral_count } }
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

# def get_fb_friends
#   url = "#{GRAPH_URL}/#{user.id}/friends?access_token=#{ENV["ACCESS_TOKEN"]}"
#   response = HTTParty.get(url)
#   response = JSON.parse(response.body)
#   puts response.inspect
#   response
# end

# def revoke_permissions
#   url = "#{GRAPH_URL}/#{user.id}/permissions?access_token=#{ENV["ACCESS_TOKEN"]}"
#   response = HTTParty.delete(url)
#   puts response.inspect
#   response
# end