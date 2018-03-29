require 'rubotnik'
# require_relative all files in "bot" folder or do it by hand
Rubotnik::Autoloader.load('bot')

# Subscribe your bot to a Facebook Page (put access and verify tokens in .env)
# Rubotnik.subscribe(ENV['ACCESS_TOKEN'])
HTTParty.post 'https://graph.facebook.com/v2.9/me/subscribed_apps', query: { access_token: ENV["ACCESS_TOKEN"] }
HTTParty.post 'https://graph.facebook.com/v2.9/me/messenger_profile', body: [Profile::START_BUTTON, Profile::START_GREETING, Profile::SIMPLE_MENU].to_json, query: { access_token: ENV["ACCESS_TOKEN"] }

# Rubotnik.set_profile(
#   Profile::START_BUTTON, Profile::START_GREETING, Profile::SIMPLE_MENU
# )

# Generates a location prompt for quick_replies
LOCATION_PROMPT = UI::QuickReplies.location

####################### HANDLE INCOMING MESSAGES ##############################

Rubotnik.route :message do
  # listen_for_login
  listen_for_select_picks
  listen_for_misc
  listen_for_status
  listen_for_sweepcoins
  listen_for_my_picks
  listen_for_friends

  # bind 'my picks', all: true, to: :my_picks

  # bind 'earn more coins', 'earn coins', to: :earn_coins

  # bind 'sweep store', 'store', all: true, to: :sweep_store

  # bind 'lifeline', 'use lifeline', 'use a lifeline', to: :handle_lifeline, reply_with: {
  #   text: "Are you sure you want me to deduct 30 Sweepcoins from your wallet?",
  #   quick_replies: [["👍", "Yes Lifeline"], ["👎", "No Lifeline"]]
  # }

  # bind 'invite', 'share' do
  #   options = ["Save yourself with a lifeline by referring a friend 🙏", "Earn 10 Sweepcoins by referring others to play with you 🎉"]
  #   message.typing_on
  #   sleep 1.5
  #   say options.sample
  #   message.typing_on
  #   sleep 1
  #   show_invite
  #   stop_thread
  # end

  # bind 'dashboard', 'record', 'stats', 'history', 'referral', 'progress', to: :dashboard

  # bind 'picking games', to: :help_picking_games

  # bind 'spread?', to: :help_with_spread

  # bind 'stop', 'unsubscribe', 'notifications', 'preferences', 'alerts', to: :manage_updates, reply_with: {
  #    text: "I can manage your notifications below, or just tell me to 'Stop' and I'll quit buggin' you altogether ☺️",
  #    quick_replies: ["Reminders", "Game recaps", ["I'm good", 'Status']]
  # }

  # bind 'how to play', 'help', to: :how_to_play

  # bind 'prizes', 'gift card', 'money', 'amazon', to: :help_prizes

  # bind 'gift card', 'amazon', to: :gift_card

  # bind 'where', 'can', 'i', 'watch', to: :lookup_location, reply_with: {
  #   text: 'Let me know your location',
  #   quick_replies: LOCATION_PROMPT
  # }

  # bind 'image', to: :show_image

  default do
    @api = Api.new
    @api.find_or_create('users', user.id)
    options = %w[😊 😄 😋 🤗 😎 🤓 😜 🤑 ]
    say options.sample, quick_replies: ["Select picks", "Status"]
  end
end

Rubotnik.route :postback do
  bind 'START' do
    begin
      @api = Api.new
      @api.find_or_create('users', user.id)
      if postback.referral
        referrer_id = postback.referral.ref
        puts "Referrer Id: #{referrer_id}"
        update_sender(user.id, referrer_id) unless referrer_id.to_i == 0
      end
      text = "Hey #{@api.user.first_name}, you finally found me!"
      say text, quick_replies: [ ["Hi, Emma!", "Welcome"] ]
      next_command :handle_walkthrough
    rescue NoMethodError => e
      say "Hmm 🤔..."
      postback.typing_on
      sleep 1.5
      postback.typing_on
      say "So I just tried to reach out to Facebook for some of your info and they seem to be having some issues."
      postback.typing_on
      sleep 0.5
      postback.typing_on
      say "...I'm Emma btw 👋, I'll keep a look out and let you know when we can get started 🎉"
      stop_thread
    end
  end
  bind 'STATUS', to: :entry_to_status_postback
  bind 'SWEEPCOINS', to: :entry_to_sweepcoins_postback
  bind 'HOW TO PLAY', to: :how_to_play_for_postback
  bind 'FRIENDS' do
    say "Get your friends involved", quick_replies: ["Challenge a friend", "Find friends"]
    next_command :entry_to_friends_postback
  end

  listen_for_select_picks_postback

  # bind 'SELECT PICKS' do 
  #   say PICKS.sample, quick_replies: [['NCAAB', 'NCAAB'], ['NBA', 'NBA'], ['MLB', 'MLB'], ['NHL', 'NHL']]
  #   next_command :entry_to_show_sports
  # end

  bind 'INVITE FRIENDS' do
    postback.typing_on
    sleep 1
    say INVITE_FRIENDS.sample
    postback.typing_on
    sleep 1
    show_invite
    stop_thread
  end

  bind 'MANAGE UPDATES' do
    text = "Tap the options below to manage your preferences 👇"
    say text, quick_replies: ["Reminders", "Game recaps", ["I'm good", 'Status']]
    next_command :manage_updates
  end

  bind 'USE LIFELINE' do
    text = "Are you sure you want me to deduct 30 Sweepcoins from your wallet?"
    say text, quick_replies: [["👍", "Yes Lifeline"], ["👎", "No Lifeline"]]
    handle_lifeline_for_postback
  end

  # bind 'DASHBOARD', to: :dashboard
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

# get '/' do
  
# end

# get '/success' do
#   get_user_friends(1842184635853672, ENV['ACCESS_TOKEN'])
#   puts "Successful authentication!"
#   puts "Access token...#{session[:access_token]}"
#   menu = [
#     {
#       content_type: 'text',
#       title: 'Friends',
#       payload: 'Friends'
#     },
#     {
#       content_type: 'text',
#       title: 'Status',
#       payload: 'Status'
#     },
#     {
#       content_type: 'text',
#       title: 'Manage updates',
#       payload: 'Manage updates'
#     }
#   ]

#   message_options = {
#     messaging_type: "UPDATE",
#     recipient: { id: 1842184635853672 },
#     message: {
#       text: "You can now take a look at how your friends are doing! #{@user_friends.inspect}",
#       quick_replies: menu
#     }
#   }
#   Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
# end

# get "/request" do
#   session[:access_token] = nil
#   redirect "https://www.facebook.com/v2.11/dialog/oauth?client_id=#{@client_id}&scope=user_friends,email&redirect_uri=#{ENV["BOT_URL"]}/oauth/facebook/callback"
# end

# get "/oauth/facebook/callback" do
#   http = Net::HTTP.new "graph.facebook.com", 443
#   request = Net::HTTP::Get.new "/oauth/access_token?client_id=#{@client_id}&redirect_uri=#{ENV["BOT_URL"]}/oauth/facebook/callback&client_secret=#{@client_secret}&code=#{params[:code]}"
#   http.use_ssl = true
#   response = http.request request
#   body = JSON.parse(response.body)
#   puts "Response: #{body.inspect}"
#   # @auth_token = body["access_token"]
#   # session[:access_token] = "EAACaERT7YxUBACURzRJKUx8Nf2XotZCG30v8MrQmIWCJTqkxURma2tKpus55GRizwqC5ZB4vqEnnfjZCX4J5EQdCyOZBT2bOkcQeXOsVhQuMvGwXIs6vF701KWqNgnTZBtBgNZCyrHZCOEF8MiJ6JxQ9wHKZBa9LSjQnt5abyWZCubQZDZD"
#   session[:access_token] = body["access_token"]
#   redirect "/success"
# end

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
