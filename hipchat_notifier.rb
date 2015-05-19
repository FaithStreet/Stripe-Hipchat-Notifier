$:.unshift File.expand_path('../lib', __FILE__)

require 'rubygems'
require 'sinatra'
require 'hipchat'
require 'json'

require 'hipchat_service'
require 'hipchat_message'

use Rack::Auth::Basic, "Restricted Area" do |username, password|
  username == ENV['AUTH_USERNAME'] and password == ENV['AUTH_PASSWORD']
end

get '/' do
  'Success.'
end

post '/stripe' do
  request.body.rewind

  request_body = request.body.read
  message = HipchatMessage.new_from_request(request_body).to_h

  HipchatService.new.send_message(message)
end
