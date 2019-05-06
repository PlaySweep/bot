require 'faraday'
require 'json'
require 'hash_dot'
require 'base64'
require 'open-uri'

require 'faraday'
require 'json'

API_URL = "#{ENV["API_URL"]}/v1/budweiser"
ADMIN_URL = "#{ENV["API_URL"]}/admin"

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

    def self.all
      response = @conn.get("#{API_URL}/users")
      users = JSON.parse(response.body)['users']
      users.map { |attributes| new(attributes) }
    end

    def self.find uuid
      @conn = Faraday.new(API_URL)
      @conn.headers["Authorization"] = uuid
      response = @conn.get("#{API_URL}/users/#{uuid}")
      attributes = JSON.parse(response.body)['user']
      new(attributes)
    end

    def self.find_or_create facebook_uuid, team: nil, source: nil, referrer_uuid: nil
      @conn = Faraday.new(API_URL)
      @conn.headers["Authorization"] = facebook_uuid
      response = @conn.get("#{API_URL}/users/#{facebook_uuid}")
      attributes = JSON.parse(response.body)['user']
      if attributes.empty?
        if referrer_uuid
          create(facebook_uuid, team: team, referrer_uuid: referrer_uuid)
        elsif source
          create(facebook_uuid, team: team, source: source)
        else
          create(facebook_uuid)
        end
      else
        find(facebook_uuid)
      end
      find(facebook_uuid)
    end

    def self.create facebook_uuid, team: nil, source: nil, referrer_uuid: nil
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
            :referral => source ? source : referrer_uuid ? "referral_#{referrer_uuid}" : "landing_page"
          } 
        }
        
        if team
          response = source ? @conn.post("#{API_URL}/users?team=#{team}", params) : @conn.post("#{API_URL}/users?referrer_uuid=#{referrer_uuid}", params)
        else
          response = @conn.post("#{API_URL}/users", params)
        end

        attributes = JSON.parse(response.body)['user']
        new(attributes)
      else
        params = { :user => 
          { 
            :facebook_uuid => facebook_uuid,
            :referral => source ? source : referrer_uuid ? "referral_#{referrer_uuid}" : "landing_page"
          } 
        }
        response = team ? @conn.post("#{API_URL}/users?team=#{team}", params) : @conn.post("#{API_URL}/users", params)
        attributes = JSON.parse(response.body)['user']
        new(attributes)
      end
    end

    def update_referral referred_facebook_uuid:
      params = { :user => { :referral_count => @data['referral_count'] += 1, :friend_uuid => referred_facebook_uuid } }
      response = @conn.patch("#{API_URL}/users/#{@facebook_uuid}", params)
      if response.status == 200
        send_confirmation(@facebook_uuid, referred_facebook_uuid)
        puts "👍"
      else
        puts "⁉️"
      end
    end

    def update uuid:, team:
      @conn = Faraday.new(API_URL)
      @conn.headers["Authorization"] = uuid
      response = @conn.patch("#{API_URL}/users/#{uuid}?team=#{team}", { :user => {:confirmed => true} })
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
      conn = Faraday.new(API_URL)
      conn.headers["Authorization"] = facebook_uuid
      response = conn.get("slates")
      events = JSON.parse(response.body)['slates']
      events.map { |attributes| new(attributes) }
    end

    # def self.find id:
    #   response = Faraday.get("#{API_URL}/users/#{facebook_uuid}/slates/#{id}")
    #   attributes = JSON.parse(response.body)['slate']
    #   new(attributes)
    # end

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
      conn = Faraday.new(ADMIN_URL)
      response = conn.get("teams?active=true")
      collection = JSON.parse(response.body)["teams"]
      collection.map { |attributes| new(attributes) }
    end

  end

end