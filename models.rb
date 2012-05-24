# Contains basic Sequel models

class Bookmark < Sequel::Model
  many_to_one :user
end

class User < Sequel::Model
  one_to_many :bookmarks
end