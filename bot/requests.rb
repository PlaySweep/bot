GRAPH_URL = 'https://graph.facebook.com/v2.8'
SWEEP_API = ENV["API_URL"]

def get_fb_user
  url = "#{GRAPH_URL}/#{user.id}?fields=first_name,last_name&access_token=#{ENV['ACCESS_TOKEN']}"
  uri = URI(url)
  response = Net::HTTP.get_response(uri)
  response = JSON.parse(response.body)
  @graph_user = response
end

def get_or_set_user
  @new_user = false
  get_fb_user unless @graph_user
  puts "Graph user...#{@graph_user.inspect}"
  url = "#{SWEEP_API}/api/v1/users/#{@graph_user['id']}"
  response = HTTParty.get(url)
  response = JSON.parse(response.body)
  if response["user"].empty?
    url = "#{SWEEP_API}/api/v1/users"
    params = { :user => { :facebook_uuid => @graph_user["id"], :first_name => @graph_user["first_name"], :last_name => @graph_user["last_name"] } }
    response = HTTParty.post(url, query: params)
    if response.code == 200
      @new_user = true
    end
  end
  response
end

def get_user_friends user_id, access_token
  url = "#{GRAPH_URL}/#{user_id}/friends?access_token=#{access_token}"
  uri = URI(url)
  response = Net::HTTP.get_response(uri)
  response = JSON.parse(response.body)
  @user_friends = response

def update_sender id, referral_count
  url = "#{SWEEP_API}/api/v1/users/#{id}"
  response = HTTParty.get(url)
  response = JSON.parse(response.body)
  referral_count = response["user"]["current_streak"]
  puts "User referral count was: #{referral_count}"
  new_referral_count = referral_count + 1
  params = { :user => { :referral_count => new_referral_count } }
  response = HTTParty.patch(url, query: params)
  puts "Updated User ID: #{id} to referral count => #{new_referral_count}" if response.code == 200
end

def set_notification_settings type, action
  url = "#{SWEEP_API}/api/v1/users/#{user.id}"
  params = { :user => { type => action } }
  response = HTTParty.patch(url, query: params)
end

def get_status
  puts "get_status " * 50
  url = "#{SWEEP_API}/api/v1/users/#{user.id}/picks" 
  response = HTTParty.get(url)
  response = JSON.parse(response.body)
  user.session[:history] = response["history"]
  user.session[:upcoming] = response["upcoming"]
  user.session[:in_progress] = response["in_progress"]
  user.session[:current] = response["current"]
  user.session[:completed] = response["completed"]
end

def get_picks
  url = "#{SWEEP_API}/api/v1/picks" 
  response = HTTParty.get(url)
  response = JSON.parse(response.body)
  @picks = response["picks"]
end

def get_recently_completed
  url = "#{SWEEP_API}/api/v1/picks?recently_completed=true" 
  response = HTTParty.get(url)
  response = JSON.parse(response.body)
  @recently_completed = response["picks"]
end

def graph_api options
  url = "#{GRAPH_URL}/#{user.id}?access_token=#{ENV["ACCESS_TOKEN"]}"
  response = HTTParty.get(url)
  response = JSON.parse(response.body)
  puts response.inspect
  response
end

def test_api
  puts "Running in the rake file..."
end

def get_user_picks id
  url = "#{SWEEP_API}/api/v1/users/#{id}/picks" 
  response = HTTParty.get(url)
  response = JSON.parse(response.body)
  response["upcoming"]
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