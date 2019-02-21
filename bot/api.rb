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
    attr_reader :id, :facebook_uuid, :first_name, :last_name, :confirmed 

    def initialize attributes
      @id = attributes['id']
      @facebook_uuid = attributes['facebook_uuid']
      @first_name = attributes['first_name']
      @last_name = attributes['last_name']
      @confirmed = attributes['confirmed']
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

    def self.find_or_create facebook_uuid
      @conn = Faraday.new(API_URL)
      @conn.headers["Authorization"] = facebook_uuid
      response = @conn.get("#{API_URL}/users/#{facebook_uuid}")
      attributes = JSON.parse(response.body)['user']
      if attributes.empty?
        create(facebook_uuid)
      else
        find(facebook_uuid)
      end
      find(facebook_uuid)
    end

    def self.create facebook_uuid
      response = Faraday.get("https://graph.facebook.com/v2.11/#{facebook_uuid}?fields=first_name,last_name,profile_pic,gender,timezone&access_token=EAACaERT7YxUBAKZBTyJYwL8CUZC6MoTXped8HdmGGCtxm2nz2zYQPmVWDsKzu1zuaQcYWnqtzLvlcRNwNem6vRoEuxUSUnmEwZAPUS3Yf12Ka40F3bOAjuJjf5yApzNhgV3KiHUsz7r0jwjd4gdyrWizKqb9ML5tlp5w7oVjtgjmg5QcS8o")
      user = JSON.parse(response.body)
      params = { :user => 
        { 
          :facebook_uuid => user.has_key?('id') ? user['id'] : nil, 
          :first_name => user.has_key?('first_name') ? user['first_name'] : nil, 
          :last_name => user.has_key?('last_name') ? user['last_name'] : nil, 
          :profile_pic => user.has_key?('profile_pic') ? user['profile_pic'] : nil, 
          :gender => user.has_key?('gender') ? user['gender'] : nil, 
          :timezone => user.has_key?('timezone') ? user['timezone'] : nil 
        } 
      }
      response = @conn.post("#{API_URL}/users", params)
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

  class Pick
    # attr_reader :id, :selected

    # def initialize attributes
    #   @id = attributes['id']
    #   @selected = attributes['selected']
    # end

    # def self.create facebook_uuid:, attributes:
    #   conn = Faraday.new(API_URL)
    #   conn.headers["Authorization"] = facebook_uuid
    #   params = { :pick => { event_id: attributes[:event_id], selected_id: attributes[:selected_id] } }
    #   conn.post("#{API_URL}/users/#{facebook_uuid}/picks", params)
    #   if response.status == 200
    #     attributes = JSON.parse(response.body)['pick']
    #     new(attributes)
    #   else
    #     false
    #   end
    # end

  end

end