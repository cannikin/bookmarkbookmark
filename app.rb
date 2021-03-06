require 'bundler'
Bundler.setup
require 'sinatra'
require 'sinatra/sequel'

require './config/database'
require './models'

configure do
  enable :logging
end

# Testing page
get '/' do
  @user = User.first
  erb :index
end

get '/views/index.erb' do
  @user = User.first
  erb :index
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


get '/bkbk?:format?.js' do
  if @user = User.where(:uuid => params[:u]).first
    @js_lib = File.read("public/javascripts/#{params[:lib]}.min.js")
    @styles = render_styles
    
    headers "Content-Type" => "application/javascript"
    if params[:format] and params[:format] == '.min'
      uglify 'bookmark.js.erb'
    else
      erb :'bookmark.js'
    end
  else
    not_found
  end
end


# List bookmarks
get '/:u/bookmarks' do
  if @user = User.where(:uuid => params[:u]).first
    bookmarks = Bookmark.where(:user_id => @user.id).order(:created_at, :id).collect { |b| bookmark_output(b) }
      
    callback_wrapper do
      bookmarks.to_json
    end
  else
    not_found
  end
end


# Add a bookmark
get '/:u/bookmarks/create' do
  if @user = User.where(:uuid => params[:u]).first
    new_bookmark_id = Bookmark.insert(:title => params[:title], :link => params[:link], :created_at => time_format(Time.now), :user_id => @user.id, :uuid => UUID.new.generate)
    bookmark = bookmark_output(Bookmark.where(:id => new_bookmark_id).first)
    
    callback_wrapper(201) do
      bookmark.to_json
    end
  else
    not_found
  end
end

# post '/:u/bookmarks' do
# 
# end


# Edit a bookmark
get '/:u/bookmarks/:b/update' do
  if @user = User.where(:uuid => params[:u]).first
    if bookmark = Bookmark.where(:user_id => @user.id, :uuid => params[:b]).first
      bookmark.update :title => params[:title], :link => params[:link]

      callback_wrapper do
        bookmark_output(bookmark).to_json
      end
    else
      not_found
    end
  else
    not_found
  end
end

# put '/:u/bookmarks/:b' do
# 
# end


# Remove a bookmark
get '/:u/bookmarks/:b/destroy' do
  if @user = User.where(:uuid => params[:u]).first
    if bookmark = Bookmark.where(:user_id => @user.id, :uuid => params[:b]).first
      old_bookmark = bookmark.dup
      bookmark.delete
      
      callback_wrapper do
        bookmark_output(old_bookmark).to_json
      end
    else
      not_found
    end
  else
    not_found
  end
end

# delete '/:u/bookmarks/:b' do
# 
# end


not_found do
  404
end


helpers do
  
  # Wraps the response in a JSONP callback if one was given
  def callback_wrapper(code=200)
    output = yield
    if params[:callback]
      headers 'Content-Type' => 'application/javascript'
      output = params[:callback] + '(' + output + ');'
    else
      headers 'Content-Type' => 'application/json'
    end
    status code
    return output
  end
  
  # Returns the host and port for this request
  def host_with_port
    request.host + (request.port == 80 ? '' : ':' + request.port.to_s)
  end
  
  # Runs the named JS file through the Uglifier gem
  def uglify(file)
    #'hello world'
    template = Tilt.new(File.join('views',file)).render(self)
    Uglifier.compile(template)
    #Uglifier.compile(ERB.new(File.read(File.join('views', file))).result(binding).force_encoding('UTF-8').gsub(/^#.*?\n/,''))
  end
  
  def bookmark_output(bookmark)
    { bookmark.uuid => { :title => bookmark.title, :link => bookmark.link, :created_at => time_format(bookmark.created_at) }}
  end
  
  def time_format(time)
    time.strftime('%Y-%m-%d %H:%M:%S')  
  end
  
  def render_styles
    style_template = Tilt::ERBTemplate.new('views/styles.css.sass.erb').render(self)
    Tilt::SassTemplate.new(:style => :compressed) { style_template }.render.chomp
  end
  
end