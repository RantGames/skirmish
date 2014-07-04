class Game::Turn < ActiveRecord::Base
  belongs_to :match
  has_many :moves
end
