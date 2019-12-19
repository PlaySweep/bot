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
          if referral.ref.start_with?("referral")
            referral_code = referral.ref.split('?')[-1].split('=')[-1]
            Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, referral_code: referral_code, source: "referred")
            puts "Friend referral: #{referral_code}"
          elsif referral.ref.include?("lp")
            ref = referral.ref.split('_').map(&:capitalize)[0]
            source = referral.ref
            Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, team: ref, source: source)
            puts "Landing page: ref => #{ref} source => #{source}"
          else
            ref = referral.ref.split('_').map(&:capitalize)[0]
            Sweep::User.find_or_create(facebook_uuid: user.id, onboard: true, team: ref, source: "social_media")
            puts "Social Media Post: ref => #{ref}"
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