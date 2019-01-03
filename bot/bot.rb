require 'rubotnik'
require 'popcorn'
require 'hash_dot'
require 'wit'
Rubotnik::Autoloader.load('bot')

Rubotnik.subscribe(ENV['ACCESS_TOKEN'])
Rubotnik.set_profile(
  Profile::START_BUTTON, Profile::START_GREETING
)

# HTTParty.post 'https://graph.facebook.com/v2.9/me/subscribed_apps', query: { access_token: ENV["ACCESS_TOKEN"] }
# HTTParty.post 'https://graph.facebook.com/v2.9/me/messenger_profile', body: [Profile::START_BUTTON, Profile::START_GREETING].to_json, query: { access_token: ENV["ACCESS_TOKEN"] }

# LOCATION_PROMPT = UI::QuickReplies.location
# EMAIL_PROMPT = UI::QuickReplies.email

Rubotnik.route :postback do
  start
end

Rubotnik.route :message do
  unless message.messaging['message']['attachments'] && message.messaging['message']['attachments'].any?
    response = $wit.message(message.text).to_dot
    entities = response.entities.keys

    puts "🔥" * 10
    puts "Entity: #{entities}"
    unsubscribe if entities.include?("unsubscribe")
    fetch_picks if entities.include?("make_picks")
    fetch_status if entities.include?("status")
    trigger_invite if entities.include?("share")
    show_how_to_play if entities.include?("how_to_play")
    show_rules if entities.include?("rules")
    show_prizes if entities.include?("prizes")
    send_help if entities.include?("help")
    default do
      say "I do not follow..."
      stop_thread
    end unless entities
  end
end