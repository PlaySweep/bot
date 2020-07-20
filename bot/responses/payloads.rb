def check_for_payloads
  
  case message.quick_reply
  when "START"
    puts "Does this ever run on I'm Ready ad?"
    onboard
  when "PLAY READY"
    check_confirmed_and_fetch_picks
  when "PLAY"
    fetch_picks
  when "PLAY NOW"
    fetch_picks
  when "LEADERBOARD"
    fetch_leaderboard
  when "OWNER LEADERBOARD"
    fetch_owner_leaderboard
  when "SHARE"
    trigger_invite
  when "HOW TO PLAY START"
    general_how_to_play
  when "PRIZING START"
    start_prizes
  when "PRIZING FAQ"
    general_prizing_info
  when "PRIZING STATUS"
    my_prizing_info
  when "HELP"
    start_help
  when "HUMAN"
    help
  else
    if message.quick_reply.include?("!")
      team = message.quick_reply.split("!", -1)[0]
      onboard_for(team: team)
    end
    stop_thread
  end
  
end

def onboard
  source = "payload_#{message.text.split(' ').map(&:downcase)[1..-1].join('')}"
  Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, source: source)
  stop_thread
end

def onboard_for team:
  abbreviation = team.split("_").map(&:downcase).join("_")
  puts "#{abbreviation} from onboard method"
  Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, team: team)
  stop_thread
end