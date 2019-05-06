class Base < ActiveResource::Base
  self.include_format_in_path = false
  self.site = "https://api-beta.playsweep.com/v1/budweiser"
end