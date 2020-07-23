require 'hash_dot'
require 'httparty'

def owner_start
  begin
    bind postback.payload do
      puts "👀" * 10
      puts "Running the payload bind in owner start..."
      puts "👀" * 10
      if postback.payload.include?("!")
        puts "Running team payload with !"
        puts "Running team payload with !"
        puts "Running team payload with !"
        team = postback.payload.split("!", -1)[0]
        initials = fetch_team(team)
        abbreviation = team.split("_").map(&:downcase).join("_")
        puts "#{abbreviation} from onboard method"
        Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, team: initials, source: postback.referral.ad_id ? "ad_#{postback.referral.ad_id}" : "ad_id")
        stop_thread
      end
    end
  rescue => exception
    puts "owner start exception => #{exception.inspect}"
  end
end

def fetch_team abbreviation
  if abbreviation == "reds"
    return "CIN"
  elsif abbreviation == "nationals"
    return "WSH"
  end
end