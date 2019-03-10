require 'faraday'
require 'json'
require 'hash_dot'
require 'base64'
require 'open-uri'

require 'faraday'
require 'json'

API_URL = "#{ENV["API_URL"]}/v1/budweiser"

module Sweep
  Hash.use_dot_syntax = true

  class User
    attr_reader :id, :facebook_uuid, :first_name, :last_name, :confirmed, :locked, :preference 

    def initialize attributes
      @id = attributes['id']
      @facebook_uuid = attributes['facebook_uuid']
      @first_name = attributes['first_name']
      @last_name = attributes['last_name']
      @confirmed = attributes['confirmed']
      @locked = attributes['locked']
      @preference = attributes['preference']
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

    def self.find_or_create facebook_uuid, source: nil, referrer_uuid: nil
      @conn = Faraday.new(API_URL)
      @conn.headers["Authorization"] = facebook_uuid
      response = @conn.get("#{API_URL}/users/#{facebook_uuid}")
      attributes = JSON.parse(response.body)['user']
      if attributes.empty?
        if referrer_uuid
          create(facebook_uuid, referrer_uuid: referrer_uuid)
        elsif source
          create(facebook_uuid, source: source)
        else
          create(facebook_uuid)
        end
      else
        find(facebook_uuid)
      end
      find(facebook_uuid)
    end

    def self.create facebook_uuid, source: nil, referrer_uuid: nil
      response = Faraday.get("https://graph.facebook.com/v3.2/#{facebook_uuid}?fields=first_name,last_name,profile_pic,email,timezone&access_token=#{ENV["ACCESS_TOKEN"]}")
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
      response = referrer_uuid ? @conn.post("#{API_URL}/users?referrer_uuid=#{referrer_uuid}", params) : @conn.post("#{API_URL}/users", params)
      attributes = JSON.parse(response.body)['user']
      new(attributes)
    end

    def update_referral referred_facebook_uuid:
      params = { :user => { :referral_count => @data['referral_count'] += 1, :friend_uuid => referred_facebook_uuid } }
      response = @conn.patch("#{API_URL}/users/#{@facebook_uuid}", params)
      if response.status == 200
        $tracker.track(@api.user.id, "User Made Referral")
        send_confirmation(@facebook_uuid, referred_facebook_uuid)
        puts "👍"
      else
        puts "⁉️"
      end
    end

    def update params
      response = @conn.patch("#{API_URL}/users/#{@facebook_uuid}", { :user => params })
      if response.status == 200
        puts "👍"
      else
        puts "⁉️"
      end
    end

  end

  class Preference
    attr_reader :id, :owner_id

    def initialize attributes
      @id = attributes['id']
      @owner_id = attributes['owner_id']
    end

    def self.update owner_id, facebook_uuid
      @conn = Faraday.new(API_URL)
      @conn.headers["Authorization"] = facebook_uuid
      user = Sweep::User.find(facebook_uuid)
      response = @conn.patch("#{API_URL}/users/#{facebook_uuid}/preferences/#{user.preference.id}", { preference: { owner_id: owner_id } })
    end

    def self.update_by_team team, facebook_uuid
      @conn = Faraday.new(API_URL)
      @conn.headers["Authorization"] = facebook_uuid
      user = Sweep::User.find(facebook_uuid)
      response = @conn.get("#{API_URL}/preferences/#{user.preference.id}/set_owner?team=#{team}")
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

end