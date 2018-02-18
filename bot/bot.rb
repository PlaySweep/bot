require 'rubotnik'
# require_relative all files in "bot" folder or do it by hand
Rubotnik::Autoloader.load('bot')

# Subscribe your bot to a Facebook Page (put access and verify tokens in .env)
Rubotnik.subscribe(ENV['ACCESS_TOKEN'])

# Set welcome screen, "get started" button and a menu (all optional)
# Edit profile.rb before uncommenting the following lines:

Rubotnik.set_profile(
  Profile::START_BUTTON, Profile::START_GREETING, Profile::SIMPLE_MENU
)

# Generates a location prompt for quick_replies
LOCATION_PROMPT = UI::QuickReplies.location

####################### HANDLE INCOMING MESSAGES ##############################

Rubotnik.route :message do
  $api.find_fb_user(user.id) unless $api.fb_user

  bind 'login', 'facebook' do
    show_login
  end

  bind 'current', 'status', to: :status

  bind 'upcoming', to: :upcoming_picks

  bind 'live', 'in progress', to: :in_progress_picks

  bind 'invite', 'earn', 'mulligans' do
    show_invite
  end

  bind 'feedback', to: :feedback do
    feedback
  end

  bind 'ok!', 'nah, I got this!', to: :walkthrough do
    walkthrough
  end

  bind 'dashboard', 'record', 'stats', 'history', 'referral', 'progress', to: :dashboard

  bind 'matchups', all: true, to: :show_sports, reply_with: {
    text: "Sports 👇",
    quick_replies: [['NFL', 'NFL'], ['NBA', 'NBA']]
  }
  bind 'make picks', all: true, to: :show_sports, reply_with: {
    text: "Sports 👇",
    quick_replies: [['NFL', 'NFL'], ['NBA', 'NBA']]
  }
  bind 'select picks', all: true, to: :show_sports, reply_with: {
    text: "Sports 👇",
    quick_replies: [['NFL', 'NFL'], ['NBA', 'NBA']]
  }
  bind 'select games', all: true, to: :show_sports, reply_with: {
    text: "Sports 👇",
    quick_replies: [['NFL', 'NFL'], ['NBA', 'NBA']]
  }
  bind 'games', all: true, to: :show_sports, reply_with: {
    text: "Sports 👇",
    quick_replies: [['NFL', 'NFL'], ['NBA', 'NBA']]
  }

  bind 'notifications', 'preferences', 'alerts', to: :manage_updates, reply_with: {
     text: "Tap the options below to manage your preferences 👇",
     quick_replies: ["Reminders", "In-game", "Game recaps", ["I'm done", 'Status']]
  }

  # bind 'where', 'can', 'i', 'watch', to: :lookup_location, reply_with: {
  #   text: 'Let me know your location',
  #   quick_replies: LOCATION_PROMPT
  # }

  # Look for more UI examples in commands/ui_examples.rb
  # Rubotnik currently supports Image, Button Template and Carousel
  # bind 'image', to: :show_image

  default do
    say "Help me help you, what is it that you're looking to do?", quick_replies: [["Select picks", "Select picks"], ["Status", "Status"]]
  end
end

####################### HANDLE INCOMING POSTBACKS ##############################

Rubotnik.route :postback do
  $api.find_fb_user(user.id) unless $api.fb_user

  bind 'START', to: :start 

  bind 'SEND FEEDBACK' do
    text = "We're new. We know we got a lot to improve on 🔧\n\nBut if you're into this sort of thing, let us know how we can make your Sweep experience better 😉"
    say text, quick_replies: [["Send feedback", "Send feedback"], ["I'm good", "I'm good"]]
    stop_thread
  end

  bind 'STATUS' do
    status
  end

  bind 'UPCOMING' do
    upcoming_picks
  end

  bind 'IN PROGRESS' do
    in_progress_picks
  end

  bind 'INVITE FRIENDS' do
    text = "One way to earn Sweep coins is by referring others to play with you!\nYour friends will get some too when they play 🎉"
    say text
    show_invite
    stop_thread
  end

  bind 'MANAGE UPDATES' do
    text = "Tap the options below to manage your preferences 👇"
    say text, quick_replies: ["Reminders", "In-game", "Game recaps", ["I'm done", 'Status']]
    next_command :manage_updates
  end

  bind 'SELECT PICKS' do 
    text = "Sports 👇"
    say text, quick_replies: [['NFL', 'NFL'], ['NBA', 'NBA']]
    next_command :show_sports
  end

  bind 'DASHBOARD', to: :dashboard
end

####################### HANDLE OTHER REQUESTS (NON-FB) #########################
enable :sessions
configure do
  set :environment, ENV["RACK_ENV"]
  enable :cross_origin
end
set :allow_origin, :any
set :allow_methods, [:get, :post, :options]
set :protection, :except => [:json_csrf]
before do
  response.headers['Content-Type'] = 'application/json'
  response.headers['Access-Control-Allow-Origin'] = '*'
  response.headers['X-Frame-Options'] = 'ALLOW-FROM https://www.messenger.com/'
  response.headers['X-Frame-Options'] = 'ALLOW-FROM https://www.facebook.com/'

  @client_id = ENV["APP_ID"]
  @client_secret = ENV["APP_SECRET"]
end

get '/' do
  
end

get '/success' do
  get_user_friends(1842184635853672, ENV['ACCESS_TOKEN'])
  puts "Successful authentication!"
  puts "Access token...#{session[:access_token]}"
  menu = [
    {
      content_type: 'text',
      title: 'Friends',
      payload: 'Friends'
    },
    {
      content_type: 'text',
      title: 'Status',
      payload: 'Status'
    },
    {
      content_type: 'text',
      title: 'Manage updates',
      payload: 'Manage updates'
    }
  ]

  message_options = {
    messaging_type: "UPDATE",
    recipient: { id: 1842184635853672 },
    message: {
      text: "You can now take a look at how your friends are doing! #{@user_friends.inspect}",
      quick_replies: menu
    }
  }
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
end

get "/request" do
  session[:access_token] = nil
  redirect "https://www.facebook.com/v2.11/dialog/oauth?client_id=#{@client_id}&scope=user_friends,email&redirect_uri=#{ENV["BOT_URL"]}/oauth/facebook/callback"
end

get "/oauth/facebook/callback" do
  http = Net::HTTP.new "graph.facebook.com", 443
  request = Net::HTTP::Get.new "/oauth/access_token?client_id=#{@client_id}&redirect_uri=#{ENV["BOT_URL"]}/oauth/facebook/callback&client_secret=#{@client_secret}&code=#{params[:code]}"
  http.use_ssl = true
  response = http.request request
  body = JSON.parse(response.body)
  puts "Response: #{body.inspect}"
  # @auth_token = body["access_token"]
  # session[:access_token] = "EAACaERT7YxUBACURzRJKUx8Nf2XotZCG30v8MrQmIWCJTqkxURma2tKpus55GRizwqC5ZB4vqEnnfjZCX4J5EQdCyOZBT2bOkcQeXOsVhQuMvGwXIs6vF701KWqNgnTZBtBgNZCyrHZCOEF8MiJ6JxQ9wHKZBa9LSjQnt5abyWZCubQZDZD"
  session[:access_token] = body["access_token"]
  redirect "/success"
end

############################ TEST ON LOCALHOST #################################

# 0. Have both Heroku CLI and ngrok
# 1. Set up "Messenger" app on Facebook for Developers, fill in .env
# 2. Run 'heroku local' from console, it will load Puma on port 5000
# 3. Expose port 5000 to the Internet with 'ngrok http 5000'
# 4. Provide your ngrok http_s_(!) address in Facebook Developer Dashboard
#    for webhook validation.
# 5. Open Messenger and talk to your bot!

# P.S. While you have DEBUG environment variable set to "true" (default in .env)
# All StandardError exceptions will go to the message dialog instead of
# breaking the server.
