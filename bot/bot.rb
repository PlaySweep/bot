require 'rubotnik'
require 'popcorn'
require 'hash_dot'
require 'wit'
Rubotnik::Autoloader.load('bot')

# Rubotnik.subscribe(ENV['ACCESS_TOKEN'])
Rubotnik.set_profile(
  Profile::START_BUTTON, Profile::START_GREETING
)

# HTTParty.post 'https://graph.facebook.com/v2.9/me/subscribed_apps', query: { access_token: ENV["ACCESS_TOKEN"] }
# HTTParty.post 'https://graph.facebook.com/v2.9/me/messenger_profile', body: [Profile::START_BUTTON, Profile::START_GREETING].to_json, query: { access_token: ENV["ACCESS_TOKEN"] }

LOCATION_PROMPT = UI::QuickReplies.location
EMAIL_PROMPT = UI::QuickReplies.email

Rubotnik.route :postback do
  start
end

Rubotnik.route :message do
  unless message.messaging['message']['attachments'] && message.messaging['message']['attachments'].any?
    response = $wit.message(message.text).to_dot
    entity = response.entities.keys.first

    # trigger responses based on Wit AI entity
    unsubscribe if entity == "unsubscribe"
    fetch_picks if entity == "make_picks"
    fetch_status if entity == "status"
    trigger_invite if entity == "share"
    show_how_to_play if entity == "how_to_play"
    show_rules if entity == "rules"
    show_prizes if entity == "prizes"
    send_help if entity == "help"
    default do
      say "I do not follow..."
      stop_thread
    end unless entity
  end
end