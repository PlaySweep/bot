require 'hash_dot'
require 'httparty'

def owner_start
  begin
    if postback.payload.include?("!")
      team = postback.payload.split("!", -1)[0]
      bind team do
        abbreviation = team.split("_").map(&:downcase).join("_")
        puts "#{abbreviation} from onboard method"
        Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, team: team, source: "ad_#{postback.referral.ad_id}")
        stop_thread
      end
    end
  rescue => exception
    puts "owner start exception => #{exception.inspect}"
  end
end