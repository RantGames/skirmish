module Skirmish::MoveValidators
  class MoveValidationError < StandardError; end

  module Validation
    def initialize
      @error_message = ''
    end

    def failure_message
      @error_message
    end

    def all_in_same_city(move, game_state)
      units = game_state.get_units(move.origin_ids)
      city_id = units.first.city.id
      success = units.all? {|u| u.city.id == city_id}
      unless success
        @error_message += 'Not all units are in the same city\n'
      end
      success
    end

    def moving_to_friendly_city(move, game_state)
      city_to_move_to = game_state.get_city(move.target_id)
      city_to_move_from = game_state.get_unit(move.origin_ids.first).city
      success = city_to_move_to.player_id == move.player_id
      unless success
        @error_message += "Unit can not be moved from city (#{city_to_move_from.name}) to enemy city (#{city_to_move_to.name})\n"
      end
      success
    end

    def city_to_attack_is_enemy_owned(move, game_state)
      city = game_state.get_city(move.target_id)
      success = city.player_id != move.player_id
      unless success
        @error_message += "Attempting to attack friendly city (#{city.name})\n"
      end
      success
    end

    def at_least_one_unit_left_in_city(move, game_state)
      city = game_state.get_unit(move.origin_ids.first).city
      unit_count = move.origin_ids.count
      success = (city.units.count - unit_count) > 0
      unless success
        @error_message += "At least one unit must be left in city (#{city.name}) at all times"
      end
      success
    end
  end

  class MoveUnit
    include Validation
    def initialize(move, game_state)
      super()
      @move = move
      @game_state = game_state
    end

    def validate
      all_in_same_city(@move, @game_state) &&
      moving_to_friendly_city(@move, @game_state) &&
      at_least_one_unit_left_in_city(@move, @game_state)
    end
  end

  class AttackUnit
    include Validation
    def initialize(move, game_state)
      super()
      @move = move
      @game_state = game_state
    end

    def validate
      city_to_attack_is_enemy_owned(@move, @game_state) &&
      at_least_one_unit_left_in_city(@move, @game_state)
    end
  end

  ACTION_TO_MOVE_VALIDATOR_MAPPINGS = {
      'move_unit' => MoveUnit,
      'attack_unit' => AttackUnit
  }

  def self.validate(move, game_state)
    validator = ACTION_TO_MOVE_VALIDATOR_MAPPINGS[move.action].new(move, game_state)

    raise MoveValidationError, validator.failure_message unless validator.validate
  end
end