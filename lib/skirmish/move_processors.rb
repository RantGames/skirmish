require 'skirmish/battle_simulator'

module Skirmish::MoveProcessors
  class MoveUnit
    def self.process(move, game_state)
      unit_to_move = game_state.get_unit(move.origin_id)
      city_to_move_to = game_state.get_city(move.target_id)
      unit_to_move.city_id = city_to_move_to.id
      unit_to_move.city.reload
      unit_to_move.save
      city_to_move_to.reload
    end
  end

  class AttackUnit
    def self.process(move, game_state)
      attacking_unit = game_state.get_unit(move.origin_id)
      defending_unit = game_state.get_unit(move.target_id)
      winning_unit = Skirmish::BattleSimulator.resolve_battle(attacking_unit, defending_unit)

      if winning_unit == attacking_unit
        defending_unit.city.units << winning_unit
        defending_unit.destroy
      else
        attacking_unit.destroy
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