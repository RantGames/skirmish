class Skirmish::Player < ActiveRecord::Base
  has_many :cities
  has_many :moves
  belongs_to :game
  belongs_to :user
end
