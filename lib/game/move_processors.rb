module Game::MoveProcessors
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

  ACTION_TO_MOVE_PROCESSOR_MAPPINGS = {
      'move_unit' => MoveUnit
  }

  def self.process_move(move, game_state)
    ACTION_TO_MOVE_PROCESSOR_MAPPINGS[move.action].process(move, game_state)
  end
end