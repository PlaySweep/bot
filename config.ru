# require 'dotenv/load' # Use this if you want plain 'rackup' over 'heroku local'
require 'facebook/messenger'
require 'sinatra'
require 'mixpanel-ruby'
require_relative './bot/bot.rb'
$tracker = Mixpanel::Tracker.new(ENV['MIXPANEL_BOT_TOKEN'])

map('/webhook') do
  run Facebook::Messenger::Server
end

require "i18n"
I18n.config.available_locales = :en

# run regular Sinatra too
run Sinatra::Application
