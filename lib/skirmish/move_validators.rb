require 'skirmish/validation'

module Skirmish::MoveValidators
  class MoveValidationError < StandardError; end

  class MoveUnit
    include Skirmish::Validation
    def initialize(move, game_state)
      super()
      @move = move
      @game_state = game_state
    end

    def validate
      all_in_same_city(@move, @game_state) &&
      moving_to_friendly_city(@move, @game_state) &&
      at_least_one_unit_left_in_city(@move, @game_state) &&
      not_same_city(@move, @game_state)
    end
  end

  class AttackUnit
    include Skirmish::Validation
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

  class OneMovePerTurn
    def self.validate(move, game_state)
      turn = Skirmish::Turn.current_turn_for_game game_state.game
      turn.moves.select{|m| m.player_id == move.player_id}.count < 1
    end

    def self.failure_message
      'You have already moved once this turn'
    end
  end

  ACTION_TO_MOVE_VALIDATOR_MAPPINGS = {
      'move_unit' => MoveUnit,
      'attack_unit' => AttackUnit
  }
  GLOBAL_VALIDATORS = [OneMovePerTurn]

  def self.validate(move, game_state)
    binding.pry
    GLOBAL_VALIDATORS.each do |validator|
      raise MoveValidationError, validator.failure_message unless validator.validate(move, game_state)
    end

    validator = ACTION_TO_MOVE_VALIDATOR_MAPPINGS[move.action].new(move, game_state)

    raise MoveValidationError, validator.failure_message unless validator.validate
  end
end