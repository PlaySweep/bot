def check_for_payloads
  message.typing_on
  case message.quick_reply
  when "START"
    onboard
  when "PLAY"
    fetch_picks
  when "PLAY NOW"
    fetch_picks
  when "STATUS"
    fetch_status
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
  message.typing_off
end

def onboard
  Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true)
  stop_thread
end

def onboard_for team:
  abbreviation = team.split("_").map(&:downcase).join("_")
  puts "#{abbreviation} from onboard method"
  Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, team: team)
  stop_thread
end