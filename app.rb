require 'bundler'
Bundler.setup
require 'sinatra'


# Login/Signup
get '/' do
  haml :index
end

get '/request' do
  request.inspect
end

get '/bkbk.js' do
  @host_with_port = "//" + request.host + (request.port == 80 ? '' : ":#{request.port}")
  @js_lib = File.read("public/javascripts/#{params[:lib]}.min.js")
  @styles = Sass::Engine.new(File.read('styles.css.sass'), :style => :compressed).render.chomp
  @bookmarks = ['Google' => 'http://google.com']
  
  headers "Content-Type" => "application/javascript"
  erb :'bookmark.js'
end

# List bookmarks
get '/:user_id' do

end

# Add a bookmark
post '/:user_id/create' do

end

# Edit a bookmark
put '/:user_id/:bookmark_id/update' do

end

# Remove a bookmark
delete '/:user_id/destroy' do

end

# Create an account
post '/signup' do

end

# Login
post '/login' do

end
