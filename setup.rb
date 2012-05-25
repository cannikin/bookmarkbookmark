# Run this file once when setting up a new database.
require 'bundler'
Bundler.require

require 'sinatra'
require 'sinatra/sequel'
require 'json'
require 'logger'

require './config/database'

puts "\nThis script will destroy any existing database in db/development.sqlite3!!"
print "  Are you sure? (y|n) "
answer = gets

if answer.chomp.match(/\A[y|Y]\Z/)

  `rm db/development.sqlite3`
  
  require './models'
  
  migration "create the users table" do
    database.create_table :users do
      primary_key :id
      String      :email,     :size => 255
      String      :password,  :size => 255
      String      :uuid,      :size => 36
      Datetime    :created_at
  
      index :id,    :unique => true
      index :email, :unique => true
      index :uuid,  :unique => true
    end
  end
  
  migration "create the bookmarks table" do
    database.create_table :bookmarks do
      primary_key :id
      Integer     :user_id
      String      :title,     :size => 255
      String      :link,      :text => true
      String      :uuid,      :size => 36
      Datetime    :created_at
  
      index :id,      :unique => true
      index :user_id
      index :uuid,    :unique => true
    end
  end
  
  # Create a user for testing
  user_id = User.insert :email => 'cannikinn@gmail.com', :password => Digest::SHA1.hexdigest('bosco'), :uuid => '9c8ee790-880d-012f-bf7e-60f8472ce36e'
  Bookmark.insert :user_id => user_id, :title => 'Google', :link => 'http://www.google.com', :uuid => UUID.new.generate
  Bookmark.insert :user_id => user_id, :title => 'Lost Art Press', :link => 'http://lostartpress.com', :uuid => UUID.new.generate
  Bookmark.insert :user_id => user_id, :title => 'Amazon', :link => 'http://www.amazon.com', :uuid => UUID.new.generate
  Bookmark.insert :user_id => user_id, :title => 'Everything you always wanted to know about something but were afraid to ask', :link => 'http://www.google.com', :uuid => UUID.new.generate
  Bookmark.insert :user_id => user_id, :title => 'A9', :link => 'http://www.a9.com', :uuid => UUID.new.generate
  
  puts "\nFirst user UUID: #{User.first.uuid}\n"

end

# Just exit, don't try to start up a Sinatra server
exit 0
