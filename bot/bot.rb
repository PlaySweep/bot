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
  greeting: [
    {
      locale: 'default',
      text: ""
    }
  ]
}, access_token: ENV['ACCESS_TOKEN'])

Facebook::Messenger::Profile.set({
  get_started: {
    payload: 'START'
  }
}, access_token: ENV['ACCESS_TOKEN'])

Rubotnik.route :postback do
  start
end

Rubotnik.route :message do
  if message.quick_reply.payload == "START"
    start
  end
  sweepy = Sweep::User.find_or_create(facebook_uuid: user.id)
  if sweepy.locked
    say "Sorry #{sweepy.first_name}, you are unable to play at this time."
    stop_thread
  else
    if sweepy.confirmed  #TODO figure out a way to not call out to api every time to verify if they are confirmed
      unless message.messaging['message']['attachments'] && message.messaging['message']['attachments'].any?
        response = $wit.message(message.text).to_dot
        entity_objects = response.entities
        entities = response.entities.keys
        unsubscribe if entities.include?("unsubscribe")
        fetch_picks if entities.include?("make_picks")
        fetch_status if entities.include?("status") unless entities.include?("make_picks")
        trigger_invite if entities.include?("share")
        show_how_to_play if entities.include?("how_to_play")
        show_prizes if entities.include?("prizes")
        send_help if entities.include?("help")
        list_of_commands if entities.include?("commands")
        location if entities.include?("local_events")
        switch_prompt_message if message.text.split(' ').map(&:downcase).include?("switch") unless entities.include?("status") || entities.include?("prizes")
        
        positive_sentiment if entity_objects["sentiment"] && entity_objects["sentiment"].first["value"] == "positive" && entities.size == 1 unless message.text.split(' ').map(&:downcase).include?("switch") 
        negative_sentiment if entity_objects["sentiment"] && entity_objects["sentiment"].first["value"] == "negative" && entities.size == 1 unless message.text.split(' ').map(&:downcase).include?("switch") 
        neutral_sentiment if entity_objects["sentiment"] && entity_objects["sentiment"].first["value"] == "neutral" && entities.size == 1 unless message.text.split(' ').map(&:downcase).include?("switch") 
        default do
          say "Hmm, I do not follow that one..."
          stop_thread
        end unless entities
      end
    else
      unless message.messaging['message']['attachments'] && message.messaging['message']['attachments'].any?
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