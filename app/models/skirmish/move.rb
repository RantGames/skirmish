require 'skirmish/move_processors'
require 'skirmish/move_validators'

class Skirmish::Move < ActiveRecord::Base
  belongs_to :player, class_name: 'Skirmish::Player'
  belongs_to :turn, class_name: 'Skirmish::Turn'
  has_many :move_origins, class_name: 'Skirmish::MoveOrigin', dependent: :destroy
  validate :target_id_is_existing_city

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

private
  def target_id_is_existing_city
    unless Skirmish::City.exists? id: target_id
      errors[:target_id] << "Target id (#{target_id}) does not point to valid city"
    end
  end
end
