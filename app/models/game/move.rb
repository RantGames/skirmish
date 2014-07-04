require 'game/move_processors'

class Game::Move < ActiveRecord::Base
  belongs_to :player
  belongs_to :turn

  MOVE_UNIT = 'move_unit'

  def process(game_state)
    Game::MoveProcessors.process_move(self, game_state)
  end
end
