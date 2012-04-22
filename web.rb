#!/usr/bin/env ruby

require 'sinatra'
require 'json'

get '/' do
  haml :index
end

get '/json' do
  send_file 'socket.json'
end
