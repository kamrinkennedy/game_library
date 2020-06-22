class Game < ActiveRecord::Base 
    belongs_to :user
    has_many :platforms, through: :user
end