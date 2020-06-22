class User < ActiveRecord::Base 
    has_many :platforms
    has_many :games
    has_secure_password
    validates :username, presence: true
    validates :username, uniqueness: true

end