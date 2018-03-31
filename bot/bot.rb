require 'rubotnik'
# require_relative all files in "bot" folder or do it by hand
Rubotnik::Autoloader.load('bot')

# Subscribe your bot to a Facebook Page (put access and verify tokens in .env)
# Rubotnik.subscribe(ENV['ACCESS_TOKEN'])
Rubotnik.set_profile(
  Profile::START_BUTTON, Profile::START_GREETING, Profile::SIMPLE_MENU
)
HTTParty.post 'https://graph.facebook.com/v2.9/me/subscribed_apps', query: { access_token: ENV["ACCESS_TOKEN"] }
# HTTParty.post 'https://graph.facebook.com/v2.9/me/messenger_profile', body: [Profile::START_BUTTON, Profile::START_GREETING, Profile::SIMPLE_MENU].to_json, query: { access_token: ENV["ACCESS_TOKEN"] }

# Generates a location prompt for quick_replies
LOCATION_PROMPT = UI::QuickReplies.location

####################### HANDLE INCOMING MESSAGES ##############################

Rubotnik.route :message do
  listen_for_select_picks
  listen_for_status
  listen_for_my_picks
  listen_for_friends
  listen_for_sweepcoins
  listen_for_invite_friends
  listen_for_misc
  listen_for_actions
  listen_for_notifications
  listen_for_how_to_play
  listen_for_sweepstore

  default do
    options = %w[😊 😄 😋 🤗 😎 🤓 😜 🤑 ]
    say options.sample, quick_replies: ["Select picks", "My picks", "Status"]
  end

end

Rubotnik.route :postback do
  listen_for_start_postback
  listen_for_select_picks_postback
  listen_for_status_postback
  listen_for_my_picks_postback
  listen_for_friends_postback
  listen_for_sweepcoins_postback
  listen_for_invite_friends_postback
  listen_for_notifications_postback
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
