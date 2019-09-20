require 'rubotnik'
require 'popcorn'
require 'hash_dot'
require 'httparty'
require_relative './api.rb'
require 'wit'
require 'facebook/messenger'

Rubotnik::Autoloader.load('bot')

include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(
  access_token: ENV["ACCESS_TOKEN"],
  subscribed_fields: %w[messages messaging_postbacks messaging_referrals]
)

Facebook::Messenger::Profile.set({
  get_started: {
    payload: 'START'
  }
}, access_token: ENV['ACCESS_TOKEN'])

Rubotnik.route :postback do
  start
end

Rubotnik.route :message do
  if message.quick_reply
    check_for_payloads
  else
    sweepy = Sweep::User.find_or_create(facebook_uuid: user.id)
    if sweepy.confirmed
      unless message.messaging['message']['attachments'] && message.messaging['message']['attachments'].any? || message.text.include?("http")
        response = $wit.message(message.text).to_dot
        entities = response.entities.keys
        entity_objects = response.entities
        unsubscribe if entities.include?("unsubscribe")
        fetch_picks if entities.include?("make_picks")
        fetch_status if entities.include?("status") unless entities.include?("make_picks")
        trigger_invite if entities.include?("share")
        general_how_to_play if entities.include?("how_to_play")
        start_prizes if entities.include?("prizes")
        start_help if entities.include?("help")
        switch_prompt_message if message.text.split(' ').map(&:downcase).include?("switch") unless entities.include?("status") || entities.include?("prizes") 
        default do
          if entities.size <= 1
            if entity_objects["sentiment"] && entity_objects["sentiment"].first["value"] != "positive"
              start_help
            else
              positive_sentiment if entity_objects["sentiment"]
            end
          end 
        end
      end
    else
      unless message.messaging['message']['attachments'] && message.messaging['message']['attachments'].any? || message.text.include?("http")
        response = $wit.message(message.text).to_dot
        entities = response.entities.keys
        if entities.include?("unsubscribe")
          unsubscribe
        else
          account_confirmation
        end
      end
    end
  end
end