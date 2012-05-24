require 'bundler'
Bundler.setup
require 'sinatra'
require 'sinatra/sequel'
require 'pry'

require './config/database'
require './models'

configure do
  enable :logging
end

# Testing page
get '/' do
  haml :index
end


# Inspect the request object
get '/request' do
  request.inspect
end


# Make sure the stack is working
get '/ping' do
  User.get(:id)
  'pong'
end


get '/bkbk.js' do
  if @user = User.where(:uuid => params[:u]).first
    @js_lib = File.read("public/javascripts/#{params[:lib]}.min.js")
    @styles = Sass::Engine.new(File.read('views/styles.css.sass'), 
      :style => :compressed).render.chomp
    
    headers "Content-Type" => "application/javascript"
    erb :'bookmark.js'
  else
    User.where(:uuid => params[:u]).inspect
  end
end


# List bookmarks
get '/:u/bookmarks' do
  if @user = User.where(:uuid => params[:u]).first
    callback_wrapper do
      Bookmark.where(:user_id => @user.id).to_hash(:title, :link).to_json
    end
  else
    not_found
  end
end


# Add a bookmark
get '/:u/bookmarks/create' do
  
end

post '/:u/bookmarks' do

end


# Edit a bookmark
get '/:u/bookmarks/:bookmark_id/update' do

end

put '/:u/bookmarks/:bookmark_id' do

end


# Remove a bookmark
get '/:u/bookmarks/:bookmark_id/destroy' do

end

delete '/:u/bookmarks/:bookmark_id' do

end


not_found do
  404
end


helpers do
  
  def callback_wrapper
    output = yield
    if params[:callback]
      headers 'Content-Type' => 'application/javascript'
      output = params[:callback] + '(' + output + ');'
    else
      headers 'Content-Type' => 'application/json'
    end
    return output
  end
  
  def host_with_port
    request.host + (request.port == 80 ? '' : ':' + request.port.to_s)
  end
  
end