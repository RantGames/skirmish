module Skirmish::MoveValidators
  class MoveValidationError < StandardError; end

  class MoveUnit
    def initialize(move, game_state)
      @move = move
      @game_state = game_state

      @unit_to_move = @game_state.get_unit(move.origin_id)
      @city_to_move_to = @game_state.get_city(move.target_id)
    end

    def self.validate
      @unit_to_move.city.player_id == @city_to_move_to.player_id
    end

    def self.failure_message
      city_to_move_from = @unit_to_move.city
      "Unit can not be moved from city (#{city_to_move_from.name}) to enemy city (#{@city_to_move_to.name}"
    end
  end

  ACTION_TO_MOVE_VALIDATOR_MAPPINGS = {
      'move_unit' => MoveUnit
  }

  def self.validate(move, game_state)
    validator = ACTION_TO_MOVE_VALIDATOR_MAPPINGS[move.action].new(move, game_state)

    raise MoveValidationError, validator.failure_message unless validator.validate
  end
end