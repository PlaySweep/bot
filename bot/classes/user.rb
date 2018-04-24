require_relative 'base'

class User < Base
  self.site = "http://localhost:3000/api/v1"
  self.primary_key = :facebook_uuid
end