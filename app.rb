require 'bundler'
Bundler.setup
require 'sinatra'

get '/' do
  haml :index
end