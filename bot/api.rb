require 'faraday'
require 'json'
require 'hash_dot'
require 'base64'
require 'open-uri'

require 'faraday'
require 'json'

API_URL = "http://localhost:3000/api/v1"

module Sweep
  Hash.use_dot_syntax = true

  class User
    attr_reader :id, :facebook_uuid, :first_name, :last_name, :full_name, :streak, :losing_streak, :current_picks, :can_cash_out, :data, :email, :pending_balance, :friends

    def initialize attributes
      @id = attributes['id']
      @facebook_uuid = attributes['facebook_uuid']
      @first_name = attributes['first_name']
      @last_name = attributes['last_name']
      @full_name = attributes['full_name']
      @streak = attributes['streak']
      @losing_streak = attributes['losing_streak']
      @current_picks = attributes['current_picks']
      @can_cash_out = attributes['can_cash_out']
      @data = attributes['data']
      @pending_balance = attributes['pending_balance']
      @email = attributes['email']
      @friends = attributes['friends']
      @sport_preference = attributes['sport_preference']
      @system_preference = attributes['system_preference']
    end

    def self.all
      response = Faraday.get("#{API_URL}/users")
      users = JSON.parse(response.body)['users']
      users.map { |attributes| new(attributes) }
    end

    def self.find uuid
      response = Faraday.get("#{API_URL}/users/#{uuid}")
      attributes = JSON.parse(response.body)['user']
      new(attributes)
    end

    def self.find_or_create facebook_uuid
      response = Faraday.get("#{API_URL}/users/#{facebook_uuid}")
      attributes = JSON.parse(response.body)['user']
      if attributes.empty?
        create(facebook_uuid)
      else
        find(facebook_uuid)
      end
    end

    def self.create facebook_uuid
      response = Faraday.get("https://graph.facebook.com/v2.11/#{facebook_uuid}?fields=first_name,last_name,profile_pic,gender,timezone&access_token=#{ENV['ACCESS_TOKEN']}")
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
      response = Faraday.post("#{API_URL}/users", params)
      attributes = JSON.parse(response.body)['user']
      new(attributes)
    end

    def update_referral referred_facebook_uuid:
      params = { :user => { :referral_count => @data['referral_count'] += 1, :coins => @data['coins'] += 100 }, :friend_uuid => referred_facebook_uuid }
      response = Faraday.patch("#{API_URL}/users/#{@facebook_uuid}", params)
      if response.status == 200
        $tracker.track(@api.user.id, "User Made Referral")
        send_confirmation(@facebook_uuid, referred_facebook_uuid)
        puts "👍"
      else
        puts "⁉️"
      end
    end

    def update params
      response = Faraday.patch("#{API_URL}/users/#{@facebook_uuid}", { :user => params })
      if response.status == 200
        puts "👍"
      else
        puts "⁉️"
      end
    end

    def unsubscribe
      unsubscribe_system_preference
      unsubscribe_sport_preference
    end

    def unsubscribe_system_preference
      params = { :system_preference => { tournaments: false } }
      response = Faraday.patch("#{API_URL}/users/#{@facebook_uuid}/system_preferences/#{@system_preference.id}", params)
      if response.status == 200
        puts "👋"
      else
        puts "⁉️"
      end
    end

    def unsubscribe_sport_preference
      params = { :sport_preference => { leagues: [].to_json } }
      response = Faraday.patch("#{API_URL}/users/#{@facebook_uuid}/sport_preferences/#{@sport_preference.id}", params)
      if response.status == 200
        puts "👋"
      else
        puts "⁉️"
      end
    end

  end

  class Event
    attr_reader :id, :data, :participants, :status

    def initialize attributes
      @id = attributes['id']
      @data = attributes['data']
      @participants = attributes['participants']
      @status = attributes['status']
    end

    def self.all facebook_uuid:, type: nil
      if type.nil?
        response = Faraday.get("#{API_URL}/events?facebook_uuid=#{facebook_uuid}")
      else
        response = Faraday.get("#{API_URL}/events?facebook_uuid=#{facebook_uuid}&type=#{type}")
      end
      events = JSON.parse(response.body)['events']
      events.map { |attributes| new(attributes) }
    end

    def self.find id:
      response = Faraday.get("#{API_URL}/events/#{id}")
      attributes = JSON.parse(response.body)['event']
      new(attributes)
    end

  end

  class Pick
    attr_reader :id, :selected

    def initialize attributes
      @id = attributes['id']
      @selected = attributes['selected']
    end

    def self.create facebook_uuid:, attributes:
      params = { :pick => { event_id: attributes[:event_id], selected_id: attributes[:selected_id] } }
      response = Faraday.post("#{API_URL}/users/#{facebook_uuid}/picks", params)
      if response.status == 200
        attributes = JSON.parse(response.body)['pick']
        new(attributes)
      else
        false
      end
    end

  end

  class Payment
    attr_reader :id, :transaction_type, :amount

    def initialize attributes
      @id = attributes['id']
      @transaction_type = attributes['transaction_type']
      @amount = attributes['amount']
    end

    def self.create facebook_uuid:, attributes:
      params = { :payment => { transaction_type: "receive", amount: attributes[:amount] } }
      response = Faraday.post("#{API_URL}/users/#{facebook_uuid}/payments", params)
      attributes = JSON.parse(response.body)['payment']
      new(attributes)
    end

  end

  class Contest
    attr_reader :id, :name, :type, :status

    def initialize attributes
      @id = attributes['id']
      @name = attributes['name']
      @type = attributes['type']
      @status = attributes['status']
    end

    def self.all
      response = Faraday.get("#{API_URL}/contests")
      contests = JSON.parse(response.body)['contests']
      unless contests.nil? || contests.empty?
        contests.map { |attributes| new(attributes) }
      else
        []
      end
    end

  end

end