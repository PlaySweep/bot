require 'dotenv'
Dotenv.load('config/application.yml')

require 'facebook/messenger'
require 'sinatra'
require 'mixpanel-ruby'
require 'haversine'
require 'popcorn'
require_relative './bot/bot.rb'
$wit = Wit.new(access_token: ENV["WIT_ACCESS_TOKEN"])


Popcorn.configure do |config|
  config.api_key = ENV["POPCORNNOTIFY_API_KEY"]
end

map('/webhook') do
  run Facebook::Messenger::Server
end

require "i18n"
I18n.config.available_locales = :en

# run regular Sinatra too
run Sinatra::Application
