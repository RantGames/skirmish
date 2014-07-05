require 'skirmish/move_validators'

describe Skirmish::MoveValidators do
  describe 'move unit validator' do
    it 'does not let you move to an enemy city' do
      game = Skirmish::Game.new
      game.players = [Skirmish::Factories::Player.make, Skirmish::Factories::Player.make]
      game_state = Skirmish::GameState.new(game)
      player_ids = game.players.map(&:id)
      move = Skirmish::Move.new(action: Skirmish::Move::MOVE_UNIT,
                      origin_id: game_state.units_for_player(player_ids[0]).first.id,
                      target_id: game_state.cities_for_player(player_ids[1]).first.id)
      expect{Skirmish::MoveValidators.validate(move, game_state)}.to raise_error(Skirmish::MoveValidators::MoveValidationError)
    end
  end
end