class Game::City < ActiveRecord::Base
  has_many :units
  belongs_to :player
end
