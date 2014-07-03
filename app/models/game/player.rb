class Game::Player < ActiveRecord::Base
  has_many :cities
  has_many :units
  has_many :moves
  belongs_to :match
end
