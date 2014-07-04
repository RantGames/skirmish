class Game::Move < ActiveRecord::Base
  belongs_to :player
  belongs_to :turn

  MOVE_UNIT = 'move_unit'
end
