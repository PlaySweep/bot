require 'faraday'
require 'json'
require 'hash_dot'
require 'base64'
require 'open-uri'

require 'faraday'
require 'json'

API_URL = "#{ENV["API_ROOT_URL"]}"
ADMIN_URL = "#{ENV["ADMIN_ROOT_URL"]}"
$api = Faraday.new(API_URL)
$admin = Faraday.new(ADMIN_URL)

module Sweep
  Hash.use_dot_syntax = true

  class User
    attr_reader :id, :facebook_uuid, :first_name, :last_name, :confirmed, :locked, :roles 

    def initialize attributes
      @id = attributes['id']
      @facebook_uuid = attributes['facebook_uuid']
      @first_name = attributes['first_name']
      @last_name = attributes['last_name']
      @confirmed = attributes['confirmed']
      @locked = attributes['locked']
      @roles = attributes['roles']
    end

    def self.find uuid
      $api.headers["Authorization"] = uuid
      response = $api.get("users/#{uuid}")
      attributes = JSON.parse(response.body)['user']
      new(attributes)
    end

    def self.find_or_create facebook_uuid, team: nil, source: nil
      $api.headers["Authorization"] = facebook_uuid
      response = $api.get("users/#{facebook_uuid}")
      if response.status == 200
        attributes = JSON.parse(response.body)['user']
        if attributes.empty?
          if source
            create(facebook_uuid, team: team, source: source)
          else
            create(facebook_uuid)
          end
        else
          find(facebook_uuid)
        end
        find(facebook_uuid)
      end
    end

    def self.create facebook_uuid, team: nil, source: nil
      response = Faraday.get("https://graph.facebook.com/v3.2/#{facebook_uuid}?fields=first_name,last_name,profile_pic,email,timezone,gender,locale&access_token=#{ENV["ACCESS_TOKEN"]}")
      if response.status == 200
        user = JSON.parse(response.body)
        params = { :user => 
          { 
            :facebook_uuid => user.has_key?('id') ? user['id'] : nil, 
            :first_name => user.has_key?('first_name') ? user['first_name'] : nil, 
            :last_name => user.has_key?('last_name') ? user['last_name'] : nil, 
            :profile_pic => user.has_key?('profile_pic') ? user['profile_pic'] : nil, 
            :locale => user.has_key?('locale') ? user['locale'] : nil, 
            :gender => user.has_key?('gender') ? user['gender'] : nil, 
            :timezone => user.has_key?('timezone') ? user['timezone'] : nil,
            :referral => source ? source : "landing_page"
          } 
        }
        
        if team
          response = $api.post("users?team=#{team}", params)
        else
          response = $api.post("users", params)
        end

        attributes = JSON.parse(response.body)['user']
        new(attributes)
      else
        params = { :user => 
          { 
            :facebook_uuid => facebook_uuid,
            :referral => source ? source : "landing_page"
          } 
        }
        response = team ? $api.post("users?team=#{team}", params) : $api.post("users", params)
        attributes = JSON.parse(response.body)['user']
        new(attributes)
      end
    end

    def update uuid:, team:
      $api.headers["Authorization"] = uuid
      response = $api.patch("users/#{uuid}?team=#{team}", { :user => {:confirmed => true} })
      if response.status == 200
        puts "👍"
      else
        puts "⁉️"
      end
    end

  end

  class Slate
    attr_reader :id, :events, :status

    def initialize attributes
      @id = attributes['id']
      @events = attributes['events']
      @status = attributes['status']
    end

    def self.all facebook_uuid:, type: nil
      $api.headers["Authorization"] = facebook_uuid
      response = $api.get("slates")
      events = JSON.parse(response.body)['slates']
      events.map { |attributes| new(attributes) }
    end

    def self.find id:
      response = $api.get("users/#{facebook_uuid}/slates/#{id}")
      attributes = JSON.parse(response.body)['slate']
      new(attributes)
    end

  end

  class Team
    attr_reader :id, :name, :abbreviation, :lat, :long

    def initialize attributes
      @id = attributes['id']
      @name = attributes['name']
      @abbreviation = attributes['abbreviation']
      @lat = attributes['lat']
      @long = attributes['long']
    end

    def self.all
      response = $admin.get("teams?active=true")
      collection = JSON.parse(response.body)["teams"]
      collection.map { |attributes| new(attributes) }
    end

    def self.by_name name:
      response = $admin.get("teams?team=#{name}")
      collection = JSON.parse(response.body)["teams"]
      collection.map { |attributes| new(attributes) }
    end

  end

end