def check_for_payloads
  message.typing_on
  case message.quick_reply
  when "START"
    onboard
  when message.quick_reply.include?("!")
    team = message.quick_reply.split("!", -1)[0]
    onboard_for(team: team)
  when "STATUS"
    fetch_status
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