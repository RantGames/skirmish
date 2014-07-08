require 'rails_helper'
require 'skirmish/move_validators'

describe Skirmish::MoveValidators do
  describe 'move unit validator' do
    def run_validation_test(yml_file, error_message_matcher)
      initial, expected, moves = GameStateLoader.parse yml_file
      expect{
        Skirmish::MoveValidators.validate(moves[0], initial)
      }.to raise_error(Skirmish::MoveValidators::MoveValidationError, error_message_matcher)
    end

    it 'does not let you move to an enemy city' do
      run_validation_test('spec/yml_states/test_moving_enemy_city.yml', /.*move.*/)
    end

    it 'does not let you attack your own city' do
      run_validation_test('spec/yml_states/test_attacking_own_city.yml', /.*attack.*/)
    end

    it 'does not let you move all your units out of a city' do
      run_validation_test('spec/yml_states/test_moving_all_units_from_city.yml', /.*one unit.*/)
    end
  end
end