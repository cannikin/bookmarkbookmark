require 'logger'

configure :development do
  set :database, 'sqlite://db/development.sqlite3'
  database.logger = Logger.new($stdout)
end

configure :production do
  set :database, ENV['DATABASE_URL']
  # database.logger = Logger.new('log/database.log')
end
