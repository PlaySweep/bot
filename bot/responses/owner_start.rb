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
        abbreviation = team.split("_").map(&:downcase).join("_")
        puts "#{abbreviation} from onboard method"
        puts "postback.payload.referral => #{postback.payload.referral}"
        puts "postback.referral => #{postback.referral}"
        if postback.payload.referral.ad_id
          Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, team: team, source: "ad_#{postback.payload.referral.ad_id}")
        else
          Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, team: team, source: "issue")
        end
        stop_thread
      end
    end
  rescue => exception
    puts "owner start exception => #{exception.inspect}"
  end
end