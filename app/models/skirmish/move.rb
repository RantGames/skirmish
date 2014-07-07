require 'skirmish/move_processors'
require 'skirmish/move_validators'

class Skirmish::Move < ActiveRecord::Base
  belongs_to :player, class_name: 'Skirmish::Player'
  belongs_to :turn, class_name: 'Skirmish::Turn'
  has_many :move_origins, class_name: 'Skirmish::MoveOrigin', dependent: :destroy

  MOVE_UNIT = 'move_unit'
  ATTACK_UNIT = 'attack_unit'

  def origin_ids
    move_origins.map{|mo| mo.origin_id}
  end

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
