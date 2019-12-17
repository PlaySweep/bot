require 'hash_dot'
require 'httparty'

def start
  bind 'START' do
    begin
      referral = postback.referral
      if referral
        if referral.ad_id
          source = "ad_#{referral.ad_id}"
          Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, source: source)
        elsif referral.ref && referral.ref != ""
          if referral.ref.start_with?("rc")
            Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, referral_code: referral.ref, source: "referred")
          else
            ref = referral.ref.split('_').map(&:capitalize).join(' ').split('?')[0]
            param_key = referral.ref.split('?')[-1].split('=')[0]
            source = referral.ref.split('?')[-1].split('=')[1]
            if param_key == "source"
              Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, team: ref, source: source)
            else
              Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, team: ref)
            end
          end
        else
          Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true)
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