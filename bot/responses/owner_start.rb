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
        team = postback.payload.split("!", -1)[0].downcase
        initials = fetch_team(team)
        abbreviation = team.split("_").map(&:downcase).join("_")
        puts "#{abbreviation} from onboard method"
        Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, team: initials, source: postback.referral ? "ad_#{postback.referral.ad_id}" : "ad_id")
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
  elsif abbreviation == "marlins"
    return "MIA"
  elsif abbreviation == "yankees"
    return "NYY"
  elsif abbreviation == "d-backs"
    return "ARI"
  elsif abbreviation == "phillies"
    return "PHI"
  elsif abbreviation == "rays"
    return "TB"
  elsif abbreviation == "dodgers"
    return "LAD"
  elsif abbreviation == "orioles"
    return "BAL"
  elsif abbreviation == "rangers"
    return "TEX"
  elsif abbreviation == "white_sox"
    return "CHW"
  elsif abbreviation == "athletics"
    return "OAK"
  elsif abbreviation == "angels"
    return "LAA"
  elsif abbreviation == "padres"
    return "SD"
  elsif abbreviation == "astros"
    return "HOU"
  elsif abbreviation == "twins"
    return "MIN"
  elsif abbreviation == "cubs"
    return "CHC"
  elsif abbreviation == "cardinals"
    return "STL"
  end
end