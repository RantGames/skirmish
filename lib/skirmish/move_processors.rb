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
      starting_units_count = attacking_units.count
      binding.pry
      result = Skirmish::BattleSimulator.resolve_battle(attacking_units, defending_city)

      # todo fix hack to get around frozen objects
      attacking_units = move.origin_ids.map{|id| game_state.get_unit(id)}.compact
      if result.attacker_won?
        push_notifications(result.attacker_won?,
                           attacking_units.first.city.player,
                           defending_city.player,
                           defending_city,
                           starting_units_count - attacking_units.count)
        # todo fix hack
        attacking_units.each do |u|
          u.city = defending_city
        end
        defending_city.player_id = move.player_id
        defending_city.occupied_turn = game_state.turn_number
        defending_city.save
        attacking_units.each(&:save)
      end
    end

  private
    def self.push_notifications(attacker_won,
                                attacking_player,
                                defending_player,
                                defending_city,
                                units_lost)
      if attacker_won
        ClientNotifier.notification('notice', "#{attacking_player.name} took your city (#{defending_city.name})", defending_player.id)
        ClientNotifier.notification('notice', "You successfully captured #{defending_city.name}, losing #{units_lost} unit(s)", attacking_player.id)
      else
        ClientNotifier.notification('notice', "You failed to capture #{defending_city.name}, losing #{units_lost} unit(s)", attacking_player.id)
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