require_relative 'api.rb'

class Copy 
  attr_reader :api

  def initialize facebook_uuid
    @facebook_uuid = facebook_uuid
    @api = Api.new
  end

  def fetch_matchup_copy
    # make call to copy endpoint for matchups
  end
end