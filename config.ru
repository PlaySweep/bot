# require 'dotenv/load' # Use this if you want plain 'rackup' over 'heroku local'
require 'facebook/messenger'
require 'sinatra'
require 'mixpanel-ruby'
require_relative './bot/bot.rb'
#TODO set env var in prod
$tracker = Mixpanel::Tracker.new(ENV['MIXPANEL_BOT_TOKEN'])

map('/webhook') do
  run Facebook::Messenger::Server
end

# run regular Sinatra too
run Sinatra::Application
