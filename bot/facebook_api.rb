require 'faraday'
require 'json'
require 'hash_dot'

class FacebookApi
  Hash.use_dot_syntax = true

  attr_accessor :conn, :attachment_id

  def initialize
    @conn = Faraday.new(:url => "https://graph.facebook.com/v2.11/me/")
  end

  def message_attachment url
    params = {message: {attachment: {type: 'image', payload: { is_reusable: true, url: url}}}}
    response = @conn.post("message_attachments?access_token=#{ENV['ACCESS_TOKEN']}", params)
    @attachment_id = JSON.parse(response.body)["attachment_id"]
  end

end