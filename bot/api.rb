require 'faraday'
require 'json'
require 'hash_dot'
require 'base64'
require 'open-uri'

class Api
  Hash.use_dot_syntax = true

  attr_accessor :conn, :fb_conn, :fb_user, :user, :user_list, 
                :pick, :matchup, :matchups, :challenge_matchups, 
                :upcoming_picks, :friend, :friends, :in_progress_picks, :completed_picks, 
                :challenge, :team

  def initialize
    @conn = Faraday.new(:url => "#{ENV["API_URL"]}/api/v1/")
  end

  def fetch_all model, facebook_uuid: nil, type: nil, sport: nil
    case model
    when 'users'
      response = @conn.get("#{model}")
      @users = JSON.parse(response.body)['users']
    when 'matchups'
      if sport
        response = @conn.get("#{model}?facebook_uuid=#{facebook_uuid}&sport=#{sport}")
      else
        response = @conn.get("#{model}?facebook_uuid=#{facebook_uuid}")
      end
      @matchups = JSON.parse(response.body)['matchups']
    when 'challenge_matchups'
      response = @conn.get("#{model}")
      puts "RESPONSE: #{JSON.parse(response.body)}"
      @challenge_matchups = JSON.parse(response.body)['matchups']
    end
  end

  def fetch_user id
    response = @conn.get("users/#{id}")
    @user = JSON.parse(response.body)['user']
  end

  def fetch_team id
    response = @conn.get("teams/#{id}")
    @team = JSON.parse(response.body)['team']
  end

  def fetch_matchup id
    response = @conn.get("challenge_matchups/#{id}")
    @matchup = JSON.parse(response.body)['matchup']
  end

  def fetch_friends id
    response = @conn.get("users/#{id}/friends")
    @friends = JSON.parse(response.body)['friends']
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
    @fb_conn = Faraday.new(:url => "https://graph.facebook.com/v2.9/#{id}?fields=first_name,last_name&access_token=#{ENV['ACCESS_TOKEN']}")
    response = @fb_conn.get
    @fb_user = JSON.parse(response.body)
  end

  def find_or_create model, id
    case model
    when 'users'
      response = @conn.get("#{model}/#{id}")
      @user = JSON.parse(response.body)['user']
      if @user.empty?
        fetch_fb_user(id)
        if @fb_user
          params = { :user => { :facebook_uuid => @fb_user.id, :first_name => @fb_user.first_name, :last_name => @fb_user.last_name } }
          response = @conn.post("#{model}", params)
          @user = JSON.parse(response.body)['user']
        end
      end
    end
  end

  def create model, id, params
    case model
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
      response = @conn.patch("users/#{user_id}/#{model}/#{id}", params)
      @challenge = response['challenge']
      puts "👍" if response.status == 200
    end
  end

  def for_picks scope, id
    case scope
    when 'status'
      response = @conn.get("users/#{id}/status")
      @user = JSON.parse(response.body)['user']
      puts "👍" if response.status == 200
    when 'upcoming'
      response = @conn.get("users/#{id}/upcoming_picks")
      @upcoming_picks = JSON.parse(response.body)['picks']
    when 'in_progress'
      response = @conn.get("users/#{id}/in_progress_picks")
      @in_progress_picks = JSON.parse(response.body)['picks']
    when 'completed'
      response = @conn.get("users/#{id}/completed_picks")
      @completed_picks = JSON.parse(response.body)['picks']
    end
  end
end