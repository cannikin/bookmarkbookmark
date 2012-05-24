require 'logger'

configure :development do
  set :database, 'sqlite://db/development.sqlite3'
  database.logger = Logger.new($stdout)
end

# configure :production do
#   set :database, 'mysql2://history:GolD5Azeykn3Gl@history.c7l8gw4qwyb2.us-east-1.rds.amazonaws.com/history'
#   database.logger = Logger.new($stdout)
# end
