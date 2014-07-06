require 'skirmish/battle_simulator'

module Skirmish::MoveProcessors
  class MoveUnit
    def self.process(move, game_state)
      units_to_move = game_state.get_units(move.origin_ids)
      city_to_move_to = game_state.get_city(move.target_id)
      city_to_move_to.units << units_to_move
      city_to_move_to.save
    end
  end

  class AttackUnit
    def self.process(move, game_state)
      attacking_units = game_state.get_units(move.origin_ids)
      defending_city = game_state.get_city(move.target_id)
      result = Skirmish::BattleSimulator.resolve_battle(attacking_units, defending_city)

      if result.attacker_won?
        defending_city.units << attacking_units
        defending_city.player_id = move.player_id
      end
    end
  end

  ACTION_TO_MOVE_PROCESSOR_MAPPINGS = {
      'move_unit' => MoveUnit,
      'attack_unit' => AttackUnit,
  }

  def self.process_move(move, game_state)
    ACTION_TO_MOVE_PROCESSOR_MAPPINGS[move.action].process(move, game_state)
  end
end