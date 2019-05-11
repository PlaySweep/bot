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
      text: 'Welcome to the Bud Light Sweep!'
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
  sweepy = Sweep::User.find_or_create(user.id)
  if sweepy.locked
    say "Sorry #{sweepy.first_name}, you are unable to play at this time."
    stop_thread
  else
    if sweepy.confirmed  #TODO figure out a way to not call out to api every time to verify if they are confirmed
      unless message.messaging['message']['attachments'] && message.messaging['message']['attachments'].any?
        response = $wit.message(message.text).to_dot
        entity_objects = response.entities
        entities = response.entities.keys
        puts "Entity Objects Returned: #{entity_objects.inspect}"
        puts "Entity Keys Returned: #{entities.inspect}"
        if !sweepy.roles.first.nil?
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
          switch_prompt if entities.include?("team_select")
          default do
            say "Hmm, I do not follow that one..."
            stop_thread
          end unless entities
        else
          if entities.include?("location")
            if entity_objects["location"].first['resolved']
              fetch_teams(entity_objects["location"].first['resolved']['values'].first['coords'].to_dot)
            else
              say "You might need to be a bit more specific than #{message.text}.\n"
              prompt_team_select
            end
          elsif entities.include?("team_select")
            team_select
          else
            prompt_team_select
          end
        end
      end
    else
      confirmation_text = "Please confirm your Budweiser Sweep account below to move forward 👇"
      url = "#{ENV['WEBVIEW_URL']}/#{user.id}/account"
      show_button("Quick Setup ⚡️", confirmation_text, nil, url)
      stop_thread
    end
  end
end