require 'rubotnik'
require 'popcorn'
require 'hash_dot'
require 'httparty'
require_relative './api.rb'
require 'wit'
require 'facebook/messenger'

include Facebook::Messenger

Rubotnik::Autoloader.load('bot')

Rubotnik.route :postback do
  start
end

Rubotnik.route :message do
  begin
    sweepy = Sweep::User.find_or_create(facebook_uuid: user.id)
    if sweepy.account.active
      if message.quick_reply
        check_for_payloads
      else
        if sweepy.confirmed
          unless message.messaging['message']['attachments'] && message.messaging['message']['attachments'].any? || message.text.include?("http")
            response = $wit.message(message.text).to_dot
            entities = response.entities.keys
            entity_objects = response.entities
            unsubscribe if entities.include?("unsubscribe")
            general_how_to_play if entities.include?("how_to_play")
            fetch_picks if entities.include?("make_picks") unless entities.include?("how_to_play")
            fetch_status if entities.include?("status") unless entities.include?("make_picks")
            trigger_invite if entities.include?("share")
            start_prizes if entities.include?("prizes")
            start_help if entities.include?("help")
            switch_prompt_message if message.text.split(' ').map(&:downcase).include?("switch") unless entities.include?("status") || entities.include?("prizes") 
            positive_sentiment if entities.size < 1 && entity_objects["sentiment"] && entity_objects["sentiment"].first["value"] == "positive"
            default do
              start_help if entities.size == 1 && entities.include?("sentiment")
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
    else
      trigger_offseason
    end
  rescue Wit::Error => e
    puts "Wit AI error\n\n => #{e.inspect}"
  end
end