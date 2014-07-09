require 'rails_helper'
require 'skirmish/move_validators'
require 'skirmish/factories'

describe Skirmish::MoveValidators do
  def run_validation_test(yml_file, error_message_matcher)
    initial, expected, moves = GameStateLoader.parse yml_file
    expect{
      Skirmish::MoveValidators.validate(moves[0], initial)
    }.to raise_error(Skirmish::MoveValidators::MoveValidationError, error_message_matcher)
  end

  describe 'move unit validator' do

    it 'does not let you move to an enemy city' do
      run_validation_test('spec/yml_states/test_moving_enemy_city.yml', /.*move.*/)
    end
  end

  describe 'attack city validator' do
    it 'does not let you attack your own city' do
      run_validation_test('spec/yml_states/test_attacking_own_city.yml', /.*attack.*/)
    end

    it 'does not let you move all your units out of a city' do
      run_validation_test('spec/yml_states/test_moving_all_units_from_city.yml', /.*one unit.*/)
    end
  end

  describe 'one turn per move validator' do
    it 'does not let you play more than one move turn' do
      # if this test fails for 'undefined method city for nilclass it actually means the validation failed'
      game = Skirmish::Factories::Game.make
      game.turns.create
      cities = game.players.first.cities
      game.turns.first.moves
      game.turns.first.moves << Skirmish::Move.create(player_id: game.players.first, action: 'move_unit', target_id: cities.first.id)
      move = Skirmish::Move.new(player_id: game.players.first,
                                action: 'move_unit',
                                target_id: cities.last.id)

      expect{
        Skirmish::MoveValidators.validate(move, Skirmish::GameState.from_game(game))
      }.to raise_error(Skirmish::MoveValidators::MoveValidationError, /.*already moved.*/)
    end
  end
end