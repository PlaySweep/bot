require 'faraday'
require 'json'
require 'hash_dot'
require 'base64'
require 'open-uri'

require 'faraday'
require 'json'

API_URL = "#{ENV["API_ROOT_URL"]}"
$api = Faraday.new(API_URL)

module Sweep
  Hash.use_dot_syntax = true

  class User
    attr_reader :id, :facebook_uuid, :first_name, :last_name, :email, 
                :confirmed, :zipcode, :locked, :slug, :current_team, :current_team_is_default, 
                :account, :copies, :images, :links, :stats, 
                :latest_stats, :latest_contest_activity, :recent_orders,
                :leaderboard, :current_team_leaderboard, :current_account_leaderboard

    def initialize attributes
      attributes.each { |name, value| instance_variable_set("@#{name}", value) }
    end

    def self.find facebook_uuid:, onboard: false
      response = onboard ? $api.get("messenger/users/#{facebook_uuid}?onboard=true") : $api.get("messenger/users/#{facebook_uuid}")
      attributes = JSON.parse(response.body)['user']
      if attributes.empty?
        return false
      else
        new(attributes)
      end
    end

    def self.find_or_create facebook_uuid:, onboard: false, team: nil, referral_code: nil, source: nil
      sweepy = find(facebook_uuid: facebook_uuid, onboard: onboard)
      if sweepy
        sweepy
      else
        sweepy = create(facebook_uuid: facebook_uuid, onboard: onboard, team: team, referral_code: referral_code, source: source)
      end
      sweepy
    end

    def self.create facebook_uuid:, onboard: false, team: nil, referral_code: nil, source: nil
      graph_response = Faraday.get("https://graph.facebook.com/v3.2/#{facebook_uuid}?fields=first_name,last_name,profile_pic,email&access_token=#{ENV["ACCESS_TOKEN"]}")
      if graph_response.status == 200
        user = JSON.parse(graph_response.body)
        params = { :user => 
          { 
            :facebook_uuid => user.has_key?('id') ? user['id'] : nil, 
            :first_name => user.has_key?('first_name') ? user['first_name'] : nil, 
            :last_name => user.has_key?('last_name') ? user['last_name'] : nil, 
            :profile_pic => user.has_key?('profile_pic') ? user['profile_pic'] : nil,
            :source => source
          } 
        }
        
        if onboard
          if referral_code
            response = $api.post("users?onboard=true&referral_code=#{referral_code}", params)
          elsif team
            response = $api.post("users?onboard=true&team=#{team}", params)
          else
            response = $api.post("users?onboard=true", params)
          end
        else
          response = $api.post("users", params)
        end

        attributes = JSON.parse(response.body)['user']
        if attributes
          new(attributes)
        end
      else
        params = { :user => 
          { 
            :facebook_uuid => facebook_uuid
          } 
        }

        if onboard
          if referral_code
            response = $api.post("users?onboard=true&referral_code=#{referral_code}", params)
          elsif team
            response = $api.post("users?onboard=true&team=#{team}", params)
          else
            response = $api.post("users?onboard=true", params)
          end
        else
          response = $api.post("users", params)
        end

        attributes = JSON.parse(response.body)['user']
        if attributes
          new(attributes)
        end
      end
    end

    def unsubscribe id:
      response = $api.patch("users/#{id}?unsubscribe=true", { :user => {:active => false} })
      if response.status == 200
        puts "👍"
      else
        puts "⁉️"
      end
    end
  end

end