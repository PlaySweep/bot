require 'hash_dot'
require 'httparty'

def start
  bind 'START' do
    begin
      if postback.referral
        team = postback.referral.ref.split('_').map(&:capitalize).join(' ').split('?')[0]
        param_key = postback.referral.ref.split('?')[-1].split('=')[0]
        source = postback.referral.ref.split('?')[-1].split('=')[1]
        if param_key == "source"
          Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, team: team, source: source)
        else
          Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, team: team)
        end
      else
        Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true)
      end
    rescue NoMethodError => e
      puts "Error => #{e.inspect}\n"
      puts "With User ID => #{user.id}"
    end
  end
end