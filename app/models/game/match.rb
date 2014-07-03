class Game::Match < ActiveRecord::Base
  has_many :players
end
