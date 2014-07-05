module Skirmish::MoveValidators
  class MoveUnit
    def self.validate(move, game_state)
      unit_to_move = game_state.get_unit(move.origin_id)
      city_to_move_to = game_state.get_city(move.target_id)
      unit_to_move.city.player_id == city_to_move_to.player_id
    end
  end

  ACTION_TO_MOVE_VALIDATOR_MAPPINGS = {
      'move_unit' => MoveUnit
  }

  def self.validate(move, game_state)
    ACTION_TO_MOVE_VALIDATOR_MAPPINGS[move.action].validate(move, game_state)
  end
end