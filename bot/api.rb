require 'faraday'
require 'json'
require 'hash_dot'

class Api
  Hash.use_dot_syntax = true

  attr_reader :conn, :fb_conn, :fb_user, :user, :pick, :matchups, :upcoming_picks, :in_progress_picks, :completed_picks

  def initialize
    @conn = Faraday.new(:url => "#{ENV["API_URL"]}/api/v1/")
  end

  def all model, type: nil, sport: nil
    case model
    when 'users'
      response = @conn.get("#{model}")
      @users = JSON.parse(response.body)['users']
    when 'matchups'
      response = @conn.get("#{model}?user_id=#{@user.id}&sport=#{sport}")
      @matchups = JSON.parse(response.body)['matchups']
    end
  end

  def find_fb_user user_id
    puts "Getting facebook user..."
    @fb_conn = Faraday.new(:url => "https://graph.facebook.com/v2.8/#{user_id}?fields=first_name,last_name&access_token=#{ENV['ACCESS_TOKEN']}")
    response = @fb_conn.get
    @fb_user = JSON.parse(response.body)
  end

  def find_or_create model, id
    case model
    when 'users'
      response = @conn.get("#{model}/#{id}")
      @user = JSON.parse(response.body)['user']
      if @user.empty?
        params = { :user => { :facebook_uuid => @fb_user.id, :first_name => @fb_user.first_name, :last_name => @fb_user.last_name } }
        response = @conn.post("#{model}", params)
        @user = JSON.parse(response.body)['user']
      end
    end
  end

  def find model, id
    case model
    when 'users'
      response = @conn.get("#{model}/#{id}")
      @user = JSON.parse(response.body)['user']
    end
  end

  def create model, params
    case model
    when 'picks'
      response = @conn.post("users/#{@fb_user.id}/#{model}", params)
      @pick = JSON.parse(response.body)['pick']
    end
  end

  def update model, id, params
    case model
    when 'matchups'
      response = @conn.patch("#{model}/#{id}", params)
      puts response.body if response.status == 200
    end
  end

  def for_picks scope
    case scope
    when 'upcoming'
      response = @conn.get("users/#{@fb_user.id}/upcoming_picks")
      @upcoming_picks = JSON.parse(response.body)['picks']
    when 'in_progress'
      response = @conn.get("users/#{@fb_user.id}/in_progress_picks")
      @in_progress_picks = JSON.parse(response.body)['picks']
    when 'completed'
      response = @conn.get("users/#{@fb_user.id}/completed_picks")
      @completed_picks = JSON.parse(response.body)['picks']
    end
  end
end