GRAPH_URL = 'https://graph.facebook.com/v2.8'.freeze
SWEEP_API = 'https://e5ffb228.ngrok.io'.freeze

def get_fb_user
  url = "#{GRAPH_URL}/#{user.id}?fields=first_name,last_name&access_token=#{ENV['ACCESS_TOKEN']}"
  uri = URI(url)
  response = Net::HTTP.get_response(uri)
  response = JSON.parse(response.body)
  @graph_user = response
end

def get_or_set_user
  get_fb_user
  puts "Graph user..."
  puts @graph_user.inspect
  url = "#{SWEEP_API}/api/v1/users/#{user.id}"
  response = HTTParty.get(url)
  response = JSON.parse(response.body)
  if response["user"].empty?
    url = "#{SWEEP_API}/api/v1/users"
    params = { :user => { :facebook_uuid => @graph_user["id"], :first_name => @graph_user["first_name"], :last_name => @graph_user["last_name"] } }
    response = HTTParty.post(url, query: params)
  end
  response
end

def set_notification_settings type, action
  url = "#{SWEEP_API}/api/v1/users/#{user.id}"
  params = { :user => { type => action } }
  response = HTTParty.patch(url, query: params)
end

def get_status
  url = "#{SWEEP_API}/api/v1/users/#{user.id}/picks" 
  response = HTTParty.get(url)
  response = JSON.parse(response.body)
  user.session[:history] = response["history"]
  user.session[:upcoming] = response["upcoming"]
  user.session[:in_progress] = response["in_progress"]
  user.session[:current] = response["current"]
  user.session[:completed] = response["completed"]
end

def graph_api options
  url = "#{GRAPH_URL}/#{user.id}?access_token=#{ENV["ACCESS_TOKEN"]}"
  response = HTTParty.get(url)
  response = JSON.parse(response.body)
  puts response.inspect
  response
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