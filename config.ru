require 'dotenv'
Dotenv.load('config/application.yml')

require 'facebook/messenger'
require 'sinatra'
require 'mixpanel-ruby'
require 'haversine'
require_relative './bot/bot.rb'
$wit = Wit.new(access_token: "N7JLUA2ORNWIIPTK4V5X3N2ATJVXLCQH")

map('/webhook') do
  run Facebook::Messenger::Server
end

require "i18n"
I18n.config.available_locales = :en

# run regular Sinatra too
run Sinatra::Application
