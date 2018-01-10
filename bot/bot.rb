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

Rubotnik.route :referral do |referral|
  puts referral.sender    # => { 'id' => '1008372609250235' }
  puts referral.recipient # => { 'id' => '2015573629214912' }
  puts referral.sent_at   # => 2016-04-22 21:30:36 +0200
  puts referral.ref       # => 'MYPARAM'
end

Rubotnik.route :message do |request|
  get_status if (request.message.text || request.message.quick_reply) == 'Status'
  get_fb_user unless @graph_user

  bind 'login' do
    show_login
  end

  if (user.session[:upcoming].nil? || user.session[:upcoming].empty?) && (user.session[:in_progress].nil? || user.session[:in_progress].empty?) && (user.session[:current].nil? || user.session[:current].empty?) 
    status_text = "You have nothing in flight for the day! Get started below 👇"
    status_quick_replies = [["Select picks", "Select picks"]]
    stop_thread
  else
    user.session[:history]["current_streak"] == 1 ? wins = "win" : wins = "wins" unless user.session[:history].empty?
    user.session[:history]["current_streak"] > 0 ? emoji = "🔥" : emoji = "" unless user.session[:history].empty?
    messages = ["Here is where the rubber meets the road #{@graph_user["first_name"]}", "We always like to know where we stand, so here is where you stand so far today"]
    status_text = "#{messages.sample}.\n\nTap and scroll through the options below to get the latest updates on your picks 🙌"
    status_quick_replies = [["Wins (#{user.session[:history]["current_streak"]})", "Wins"], ["Up next (#{user.session[:upcoming].count})", "Up next"], ["Live (#{user.session[:in_progress].count})", "Live"], ["Completed (#{user.session[:current].count})", "Completed"], ["Select Picks", "Select picks"]]
  end
  bind 'current', 'status', to: :status, reply_with: {
    text: status_text,
    quick_replies: status_quick_replies
  }
  bind "'i'm", "good", "eh", "nevermind", to: :reset
  bind 'invite', 'earn', 'mulligans' do
    show_invite
  end
  bind 'send', 'feedback', all: true, to: :send_feedback, reply_with: {
    text: "We already like you, #{@graph_user["first_name"]}. There's (almost) nothing that'll hurt our feelings...\n\nType your message in the box below and one of our guys will reach out to you soon 🤝",
    quick_replies: [["Eh, nevermind", "Eh, nevermind"]]
  }
  bind 'unlock', 'game' do
    show_invite
  end
  bind 'get', 'more', 'picks', all: true, to: :more_picks
  bind 'how', 'to', 'play', to: :how_to_play
  bind 'select', 'picks', all: true, to: :select_picks
  bind 'update', 'picks', all: true, to: :select_picks
  bind 'nfl' do
    show_button_template('NFL')
  end
  # bind 'ncaaf' do
  #   show_button_template('NCAAF')
  # end
  # bind 'nba' do
  #   show_button_template('NBA')
  # end

  bind 'manage', 'updates', 'preferences', 'alerts', to: :manage_updates, reply_with: {
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
    say "We're new. We know we got a lot to improve on 🔧\n\nBut if you're into this sort of thing, let us know how we can make your Sweep experience better 😉", quick_replies: [["Send feedback", "Send feedback"], ["I'm good", "I'm good"]]
  end
end

####################### HANDLE INCOMING POSTBACKS ##############################

Rubotnik.route :postback do
  bind 'START', to: :start 
  bind 'HOW TO PLAY', to: :how_to_play # fix how to play for postback 
  bind 'SEND FEEDBACK' do
    text = "We're new. We know we got a lot to improve on 🔧\n\nBut if you're into this sort of thing, let us know how we can make your Sweep experience better 😉"
    say text, quick_replies: [["Send feedback", "Send feedback"], ["I'm good", "I'm good"]]
    stop_thread
  end
  bind 'INVITE FRIENDS' do
    text = "We're giving away a mulligan for every 3 friends that play Sweep from your referral, while your friends earn one immediately 🎉\n\nSpread the word and earn some mulligans! 😉"
    say text, quick_replies: [["Earn mulligans", "Earn mulligans"], ["I'm good", "I'm good"]]
    stop_thread
  end
  bind 'UNLOCK GAME' do
    show_invite
  end
  bind 'MORE SPORTS', to: :select_picks
  bind 'Select picks', to: :select_picks
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

  session[:oauth] ||= {}
end

get '/' do
  puts "Access token..."
  puts session[:oauth][:access_token].inspect
end

get "/request" do
  redirect "https://www.facebook.com/v2.11/dialog/oauth?client_id=#{@client_id}&scope=user_friends,email&redirect_uri=#{ENV["BOT_URL"]}/oauth/facebook/callback"
end

get "/oauth/facebook/callback" do
  session[:oauth][:code] = params[:code]

  http = Net::HTTP.new "graph.facebook.com", 443
  request = Net::HTTP::Get.new "/oauth/access_token?client_id=#{@client_id}&redirect_uri=#{ENV["BOT_URL"]}/oauth/facebook/callback&client_secret=#{@client_secret}&code=#{session[:oauth][:code]}"
  http.use_ssl = true
  response = http.request request

  body = JSON.parse(response.body)
  session[:oauth][:access_token] = body["access_token"]
  session[:oauth][:token_type] = body["token_type"]
  session[:oauth][:expires_in] = body["expires_in"]
  redirect "/"
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
