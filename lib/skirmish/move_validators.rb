module Skirmish::MoveValidators
  class MoveValidationError < StandardError; end

  class MoveUnit
    def initialize(move, game_state)
      @move = move
      @game_state = game_state
      @units_to_move = move.move_origins.map{|mo| @game_state.get_unit(mo.origin_id)}
      @city_to_move_to = @game_state.get_city(move.target_id)
    end

    def validate
      all_in_same_city(@units_to_move) && moving_to_friendly_city(@city_to_move_to, @move.player_id)
    end

    def failure_message
      if all_in_same_city(@units_to_move)
        city_to_move_from = @units_to_move.first.city
        "Unit can not be moved from city (#{city_to_move_from.name}) to enemy city (#{@city_to_move_to.name})"
      else
        'Not all units are in the same city'
      end
    end

  private
    def all_in_same_city(units)
      city_id = units.first.city.id
      units.all? {|u| u.city.id == city_id}
    end

    def moving_to_friendly_city(city_to_move_to, player_id)
      city_to_move_to.player_id == player_id
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