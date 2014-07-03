class Game::Turn < ActiveRecord::Base
  has_many :moves
end
