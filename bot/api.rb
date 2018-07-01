require 'faraday'
require 'json'
require 'hash_dot'
require 'base64'
require 'open-uri'

class Api
  Hash.use_dot_syntax = true

  attr_accessor :conn, :fb_conn, :fb_user, :user, :user_list, 
                :pick, :picks, :matchup, :matchups, :challenge_matchups, :copies,
                :upcoming_picks, :friend, :friends, :in_progress_picks, :completed_picks, 
                :challenge, :challenge_type, :team, :prop, :sports, :media, :challenge_valid,
                :payment

  def initialize
    @conn = Faraday.new(:url => "#{ENV["API_URL"]}/api/v1/")
  end

  def fetch_all model, facebook_uuid=nil, sport=nil, type=nil
    case model
    when 'users'
      response = @conn.get("#{model}")
      @users = JSON.parse(response.body)['users']
    when 'matchups'
      if sport
        response = @conn.get("#{model}?facebook_uuid=#{facebook_uuid}&type=#{type}&sport=#{sport}")
      else
        response = @conn.get("#{model}?facebook_uuid=#{facebook_uuid}")
      end
      @matchups = JSON.parse(response.body)['matchups']
    when 'challenge_matchups'
      response = @conn.get("#{model}?facebook_uuid=#{facebook_uuid}")
      @challenge_matchups = JSON.parse(response.body)['matchups']
    end
  end

  def fetch_user id
    response = @conn.get("users/#{id}")
    @user = JSON.parse(response.body)['user']
  end

  def fetch_copy facebook_uuid:, category:
    response = @conn.get("copies?facebook_uuid=#{facebook_uuid}&category=#{category}")
    @copies = JSON.parse(response.body)['copies']
  end

  def fetch_challenge user_id, id
    response = @conn.get("users/#{user_id}/challenges/#{id}")
    @challenge = JSON.parse(response.body)['challenge']
  end

  def fetch_challenge_type description
    response = @conn.get("challenge_types?description=#{description}")
    @challenge_type = JSON.parse(response.body)['challenge_type']
  end

  def fetch_team id
    response = @conn.get("teams/#{id}")
    @team = JSON.parse(response.body)['team']
  end

  def fetch_prop id
    response = @conn.get("props/#{id}")
    @prop = JSON.parse(response.body)['prop']
  end

  def fetch_media category
    response = @conn.get("media?category=#{category}")
    @media = JSON.parse(response.body)['media']
  end

  def fetch_matchup_by_teams side1, side2
    response = @conn.get("matchup/by_teams?away_side=#{side1}&home_side=#{side2}")
    @matchup = JSON.parse(response.body)['matchup']
  end

  def fetch_friends id, param=nil
    case param
    when :most_popular
      response = @conn.get("users/#{id}/friends?most_popular=true")
      @friends = JSON.parse(response.body)['friends']
    else
      response = @conn.get("users/#{id}/friends")
      @friends = JSON.parse(response.body)['friends']
    end
  end

  def fetch_picks id, param=nil
    case param
    when :in_flight
      response = @conn.get("users/#{id}/picks?in_flight=true")
      @picks = JSON.parse(response.body)['picks']
    when :pending
      response = @conn.get("users/#{id}/picks?pending=true")
      @picks = JSON.parse(response.body)['picks']
    else
      response = @conn.get("users/#{id}/picks")
      @picks = JSON.parse(response.body)['picks']
    end
  end

  def fetch_sports active: nil
    if active
      response = @conn.get("sports?active=true")
      @sports = JSON.parse(response.body)['sports']
    else
      response = @conn.get("sports")
      @sports = JSON.parse(response.body)['sports']
    end
  end

  def query_users query
    response = @conn.get("users?name=#{query}")
    @user_list = JSON.parse(response.body)['users']
  end

  def query_matchups query
    response = @conn.get("challenge_matchups?name=#{query}")
    @matchup_list = JSON.parse(response.body)['matchups']
  end

  def fetch_fb_user id
    @fb_conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/#{id}?fields=first_name,last_name,profile_pic,gender,timezone&access_token=#{ENV['ACCESS_TOKEN']}")
    response = @fb_conn.get
    @fb_user = JSON.parse(response.body)
  end

  def find_or_create model, id
    case model
    when 'users'
      response = @conn.get("#{model}/#{id}")
      @user = JSON.parse(response.body)['user']
      if (@user.nil? || @user.empty?)
        fetch_fb_user(id)
        if @fb_user
          puts "Facebook user: #{@fb_user.inspect}"
          params = { :user => 
            { 
              :facebook_uuid => @fb_user.has_key?('id') ? @fb_user.id : nil, 
              :first_name => @fb_user.has_key?('first_name') ? @fb_user.first_name : nil, 
              :last_name => @fb_user.has_key?('last_name') ? @fb_user.last_name : nil, 
              :profile_pic => @fb_user.has_key?('profile_pic') ? @fb_user.profile_pic : nil, 
              :gender => @fb_user.has_key?('gender') ? @fb_user.gender : nil, 
              :timezone => @fb_user.has_key?('timezone') ? @fb_user.timezone : nil 
            } 
          }
          response = @conn.post("#{model}", params)
          @user = JSON.parse(response.body)['user']
        end
      end
    end
  end

  def create model, id, params
    case model
    when 'users'
      response = @conn.post('users', params)
      response = JSON.parse(response.body)
      @user = response['user']
    when 'picks'
      response = @conn.post("users/#{id}/#{model}", params)
      response = JSON.parse(response.body)
      @pick = response['pick']
    when 'challenges'
      response = @conn.post("users/#{id}/#{model}", params)
      response = JSON.parse(response.body)
      @challenge = response['challenge']
    end
  end

  def update model, id, params, user_id = nil
    case model
    when 'users'
      response = @conn.patch("#{model}/#{id}", params)
      puts "👍" if response.status == 200
    when 'matchups'
      response = @conn.patch("#{model}/#{id}", params)
      puts "👍" if response.status == 200
    when 'challenges'
      @challenge_valid = false
      response = @conn.patch("users/#{user_id}/#{model}/#{id}", params)
      @challenge_valid = true if response.status == 200
    end
  end

  def for_picks scope, id
    case scope
    when 'status'
      response = @conn.get("users/#{id}/status")
      @user = JSON.parse(response.body)['user']
    end
  end

  def cash_out facebook_uuid, amount
    response = @conn.post("users/#{facebook_uuid}/payments", { :payment => {transaction_type: "receive", amount: amount} })
    response = JSON.parse(response.body)
    @payment = response['payment']
  end
end