require 'rubotnik'
require 'popcorn'
# require_relative all files in "bot" folder or do it by hand
Rubotnik::Autoloader.load('bot')

# Subscribe your bot to a Facebook Page (put access and verify tokens in .env)
Rubotnik.subscribe(ENV['ACCESS_TOKEN'])
Rubotnik.set_profile(
  Profile::START_BUTTON, Profile::START_GREETING
)

# HTTParty.post 'https://graph.facebook.com/v2.9/me/subscribed_apps', query: { access_token: ENV["ACCESS_TOKEN"] }
HTTParty.post 'https://graph.facebook.com/v2.9/me/messenger_profile', body: [Profile::START_BUTTON, Profile::START_GREETING].to_json, query: { access_token: ENV["ACCESS_TOKEN"] }

# Generates a location prompt for quick_replies
LOCATION_PROMPT = UI::QuickReplies.location
EMAIL_PROMPT = UI::QuickReplies.email

####################### HANDLE INCOMING MESSAGES ##############################

Rubotnik.route :message do |msg|
  # listen_for_media
  listen_for_select_picks
  # listen_for_location
  # listen_for_email
  # listen_for_status
  listen_for_invite_friends
  # listen_for_misc
  # listen_for_prizing
  # listen_for_challenges
  # listen_for_feedback
  # listen_for_notifications
  # listen_for_unsubscribe
  # listen_for_store
  # listen_for_live
  # bind 'Ready!', all: true do
  #   say "Here's how it works:\n\n1. 🏀️ I'll send you 3 plays every day the Knicks are on the court\n2. ☝️ Make 3 predictions\n3. 🏆 Get all 3 right and earn your way into the Budweiser Final (I'll remind you 😎)\n4. 🎉 Win some crazy, unforgettable Knicks experiences from Budweiser"
  #   url = "#{ENV['WEBVIEW_URL']}/#{user.id}/picks"
  #   show_button("PICK EM 🏀️", " Make your 3 picks now!", nil, url)
  #   stop_thread
  # end

  bind 'How do I play?', all: true do
    say "🏀️ Offical Rules 🏀️\n\n1. Type 'Make picks' to see if there are any available Budweiser Sweep Cards for the day 🏀️\n\n2. Complete your 3 picks and earn your way into a Budweiser Sweep Final if you get all of your picks correct 🏆\n\n3. Enter into the Final for a chance at winning unforgettable Knicks experiences from Budweiser 🎉"
    stop_thread
  end

  bind 'What do I win?', all: true do
    say "Exclusive Knicks prizes! Trust me, you'll want to keep playing 🏀️🏆!"
    stop_thread
  end

  bind 'I love' do
    say "Good, we're glad! Get out there and keep playing!"
    stop_thread
  end

  default do
    if message.quick_reply
      unless message.quick_reply.split(' ')[0] == 'SURVIVOR'
        capture_responses(message.text) unless message.text.nil?
      end
    else
      capture_responses(message.text) unless message.text.nil?
    end
  end

end

Rubotnik.route :postback do
  listen_for_start_postback
  # listen_for_select_picks_postback
  # listen_for_status_postback
  # listen_for_invite_friends_postback
  # listen_for_challenges_postback
  # listen_for_notifications_postback
  # listen_for_store_postback
  # listen_for_prizing_postback
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
