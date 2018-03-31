require 'faraday'
require 'json'
require 'hash_dot'
require 'base64'
require 'open-uri'

class Api
  Hash.use_dot_syntax = true

  attr_accessor :conn, :fb_conn, :fb_user, :user, :user_list, 
                :pick, :matchups, :upcoming_picks, 
                :in_progress_picks, :completed_picks

  def initialize
    @conn = Faraday.new(:url => "#{ENV["API_URL"]}/api/v1/")
  end

  def all model, type: nil, sport: nil
    case model
    when 'users'
      response = @conn.get("#{model}")
      @users = JSON.parse(response.body)['users']
    when 'matchups'
      if sport
        response = @conn.get("#{model}?user_id=#{@user.id}&sport=#{sport}")
      else
        response = @conn.get("#{model}?user_id=#{@user.id}")
      end
      @matchups = JSON.parse(response.body)['matchups']
    end
  end

  def friend_lookup friend_name
    response = @conn.get("users?friend_name=#{friend_name}")
    @user_list = JSON.parse(response.body)['users']
  end

  def find_fb_user user_id
    puts "Getting facebook user..."
    @fb_conn = Faraday.new(:url => "https://graph.facebook.com/v2.9/#{user_id}?fields=first_name,last_name&access_token=#{ENV['ACCESS_TOKEN']}")
    response = @fb_conn.get
    @fb_user = JSON.parse(response.body)
  end

  def find_or_create model, id
    case model
    when 'users'
      puts "Running find_or_create for Users model..."
      response = @conn.get("#{model}/#{id}")
      @user = JSON.parse(response.body)['user']
      if @user.empty?
        find_fb_user(id)
        if @fb_user
          params = { :user => { :facebook_uuid => @fb_user.id, :first_name => @fb_user.first_name, :last_name => @fb_user.last_name } }
          response = @conn.post("#{model}", params)
          @user = JSON.parse(response.body)['user']
        end
      end
    end
  end

  def create model, params
    case model
    when 'picks'
      response = @conn.post("users/#{@user.facebook_uuid}/#{model}", params)
      response = JSON.parse(response.body)
      @pick = response['pick']
    end
  end

  def update model, id, params
    case model
    when 'users'
      response = @conn.patch("#{model}/#{id}", params)
      puts "👍" if response.status == 200
    when 'matchups'
      response = @conn.patch("#{model}/#{id}", params)
      puts "👍" if response.status == 200
    end
  end

  def for_picks scope
    case scope
    when 'status'
      response = @conn.get("users/#{@user.facebook_uuid}/status")
      @user = JSON.parse(response.body)['user']
      puts "👍" if response.status == 200
    when 'upcoming'
      response = @conn.get("users/#{@user.facebook_uuid}/upcoming_picks")
      @upcoming_picks = JSON.parse(response.body)['picks']
    when 'in_progress'
      response = @conn.get("users/#{@user.facebook_uuid}/in_progress_picks")
      @in_progress_picks = JSON.parse(response.body)['picks']
    when 'completed'
      response = @conn.get("users/#{@user.facebook_uuid}/completed_picks")
      @completed_picks = JSON.parse(response.body)['picks']
    end
  end
end