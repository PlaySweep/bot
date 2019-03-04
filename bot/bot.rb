require 'rubotnik'
require 'popcorn'
require 'hash_dot'
require 'httparty'
require_relative './api.rb'
require 'wit'
Rubotnik::Autoloader.load('bot')

# Rubotnik.subscribe("EAAbXmgDyHk8BANmG3wxxrqr4cGU3SrWZBPbEy9EQjplstOr7NIEJwN4AMAA6WNiZAdLAAsPa7g3FrBnqW66xpJ1snZCUGfKwf4CrslKjuxYHtxdK4ZA9nSj2WgFPrw1ZB7R9L4qAgWdSXpHZAEyPawwYiZAGnHi2DZApgB6Bkaluqc6XXzKCfX9w")
Rubotnik.set_profile(
  Profile::START_BUTTON, Profile::START_GREETING
)

# HTTParty.get 'https://graph.facebook.com/v3.2/606217113124396/subscribed_apps'
HTTParty.post "https://graph.facebook.com/v3.2/606217113124396/subscribed_apps", query: { access_token: ENV["ACCESS_TOKEN"], subscribed_fields: ["name", "messages", "messaging_postbacks", "messaging_referrals"] }
# HTTParty.post 'https://graph.facebook.com/v2.6/me/messenger_profile', body: [Profile::START_BUTTON, Profile::START_GREETING].to_json, query: { access_token: ENV["ACCESS_TOKEN"] }

# LOCATION_PROMPT = UI::QuickReplies.location
# EMAIL_PROMPT = UI::QuickReplies.email

Rubotnik.route :postback do
  start
end

Rubotnik.route :message do
  sweepy = Sweep::User.find_or_create(user.id)
  if sweepy.locked
    say "Sorry, #{sweepy.first_name}, you are unable to play at this time."
    stop_thread
  else
    if sweepy.confirmed && sweepy.preference.owner_id  #TODO figure out a way to not call out to api every time to verify if they are confirmed
      unless message.messaging['message']['attachments'] && message.messaging['message']['attachments'].any?
        response = $wit.message(message.text).to_dot
        entity_objects = response.entities
        entities = response.entities.keys
        
        unsubscribe if entities.include?("unsubscribe")
        fetch_picks if entities.include?("make_picks")
        fetch_status if entities.include?("status")
        trigger_invite if entities.include?("share")
        show_how_to_play if entities.include?("how_to_play")
        show_rules if entities.include?("rules")
        show_prizes if entities.include?("prizes")
        send_help if entities.include?("help")
        list_of_commands if entities.include?("commands")
        legal if entities.include?("legal")
        location if entities.include?("local_events")
        team_select if entities.include?("team_select")
        positive_sentiment if entity_objects["sentiment"] && entity_objects["sentiment"].first["value"] == "positive" && entities.size == 1
        negative_sentiment if entity_objects["sentiment"] && entity_objects["sentiment"].first["value"] == "negative" && entities.size == 1
        neutral_sentiment if entity_objects["sentiment"] && entity_objects["sentiment"].first["value"] == "neutral" && entities.size == 1
        default do
          say "Hmm, I do not follow that one..."
          stop_thread
        end unless entities
      end
    elsif sweepy.confirmed && !sweepy.preference.owner_id && !entities.include?("team_select")
      prompt_team_select
    elsif sweepy.confirmed && !sweepy.preference.owner_id && entities.include?("team_select")
      team_select
    else
      confirmation_text = "Please confirm your Budweiser Sweep account below to move forward 👇"
      url = "#{ENV['WEBVIEW_URL']}/#{user.id}/account"
      show_button("Quick Setup ⚡️", confirmation_text, nil, url)
      stop_thread
    end
  end
end