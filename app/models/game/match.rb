class Game::Match < ActiveRecord::Base
  has_many :players
  has_many :turns
end
