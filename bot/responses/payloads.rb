def check_for_payloads
  message.typing_on
  case message.quick_reply
  when "START"
    onboard
  when message.quick_reply.include?("!")
    team = message.quick_reply.split("!", -1)[0]
    onboard_for(team: team)
  when "PLAY"
    fetch_picks
  when "STATUS"
    fetch_status
  when "SHARE"
    trigger_invite
  when "ENTRY FAQ"
    general_entry_info
  when "ENTRY DETAILS"
    entry_status
  when "HOW TO PLAY START"
    general_how_to_play
  when "PRIZING START"
    start_prizing
  when "PRIZING FAQ"
    general_prizing_info
  when "PRIZING"
    current_prizing_info
  when "PRIZING STATUS"
    my_prizing_info
  when "HUMAN"
    help
  end
  message.typing_off
end

def onboard
  Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true)
end

def onboard_for team:
  abbreviation = team.split("_").map(&:downcase).join("_")
  Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, team: team)
end