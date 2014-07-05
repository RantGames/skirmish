require 'skirmish/move_processors'

class Skirmish::Move < ActiveRecord::Base
  belongs_to :player
  belongs_to :turn

  MOVE_UNIT = 'move_unit'

  def process(game_state)
    Skirmish::MoveProcessors.process_move(self, game_state)
  end

  def validate(game_state)
    error_message = ''
    begin
      Skirmish::MoveValidators.validate(self, game_state)
    rescue Skirmish::MoveValidators::MoveValidationError => e
      error_message = e.message
    end
    error_message
  end
end
