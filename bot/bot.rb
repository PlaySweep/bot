require 'rubotnik'
require 'popcorn'
require 'hash_dot'
require 'httparty'
require_relative './api.rb'
require 'wit'
require 'facebook/messenger'

include Facebook::Messenger

Rubotnik::Autoloader.load('bot')

Facebook::Messenger::Profile.set({
  get_started: {
    payload: 'START'
  }
}, access_token: ENV['ACCESS_TOKEN'])

Rubotnik.route :postback do
  start
  owner_start
end

Rubotnik.route :message do
  
end