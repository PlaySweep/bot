require 'rubotnik'
require 'popcorn'
require 'hash_dot'
require 'httparty'
require_relative './api.rb'
require 'wit'
Rubotnik::Autoloader.load('bot')

# Rubotnik.subscribe(ENV['ACCESS_TOKEN'])
Rubotnik.set_profile(
  Profile::START_BUTTON, Profile::START_GREETING
)


HTTParty.post 'https://graph.facebook.com/v2.11/me/subscribed_apps', query: { access_token: ENV["ACCESS_TOKEN"], subscription_fields: [] }
HTTParty.post 'https://graph.facebook.com/v2.11/me/messenger_profile', body: [Profile::START_BUTTON, Profile::START_GREETING].to_json, query: { access_token: ENV["ACCESS_TOKEN"] }

# LOCATION_PROMPT = UI::QuickReplies.location
# EMAIL_PROMPT = UI::QuickReplies.email

Rubotnik.route :postback do
  start
end

Rubotnik.route :message do
  # if Sweep::User.find(user.id).confirmed #TODO figure out a way to not call out to api every time to verify if they are confirmed
    unless message.messaging['message']['attachments'] && message.messaging['message']['attachments'].any?
      Sweep::User.find_or_create(user.id)
      response = $wit.message(message.text).to_dot
      entity_objects = response.entities
      entities = response.entities.keys
      puts "Entity Objects: #{entity_objects}"
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
      positive_sentiment if entity_objects["sentiment"] && entity_objects["sentiment"].first["value"] == "positive" && entities.size == 1
      negative_sentiment if entity_objects["sentiment"] && entity_objects["sentiment"].first["value"] == "negative" && entities.size == 1
      neutral_sentiment if entity_objects["sentiment"] && entity_objects["sentiment"].first["value"] == "neutral" && entities.size == 1
      default do
        say "Hmm, I do not follow that one..."
        stop_thread
      end unless entities
    end
  # else
  #   confirmation_text = "Please confirm your Budweiser Sweep account below to move forward 👇"
  #   url = "#{ENV['WEBVIEW_URL']}/#{user.id}/account"
  #   show_button("Quick Setup ⚡️", confirmation_text, nil, url)
  #   stop_thread
  # end
end