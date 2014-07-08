require 'rails_helper'
require 'skirmish/factories'
require 'game_state_loader'

describe Skirmish::GameState, :type => :model do

  before do
    @game = Skirmish::Game.create

    @ubermouse = Skirmish::Player.create(game_id: @game.id, name: 'ubermouse')
    @copenhagen = Skirmish::City.create(name: 'Copenhagen', latitude: 55.6712674, longitude: 12.5608388)
    @copenhagen_unit = Skirmish::Unit.create(unit_type: 'infantry', attack: 1, defense: 1)
    @copenhagen.units << @copenhagen_unit
    @ubermouse.cities << @copenhagen
    @wellington = Skirmish::City.create(name: 'Wellington', latitude: -41.2443701, longitude: 174.7618546)
    @ubermouse.cities << @wellington
    @players = [@ubermouse, Skirmish::Factories::Player.make(barbarian: true)]
    @game.players = @players

    @game_state = Skirmish::GameState.new(@game)
  end

  describe 'advancing a turn' do

    def perform_reinforcements_test(player_id, expected_units_change = nil)
      cities = @game_state.cities_for_player(player_id) unless expected_units_change

      expect {
        @game_state.advance_turn(only: Skirmish::StateModifiers::Reinforcements)
      }.to change {
        @game_state.units_for_player(player_id).length
      }.by(expected_units_change || cities.length)
    end

    def stub_turns(count)
      stubbed_turns = count.times.map {
        stub_model Skirmish::Turn, game_id: @game.id
      }
      allow(@game).to receive(:turns).and_return stubbed_turns
    end

    it 'generates reinforcements' do
      stub_turns(1)
      perform_reinforcements_test(@players[0].id)
    end

    it 'does not generate reinforcements for barbarians on turns not divisible by 10' do
      stub_turns(3)
      perform_reinforcements_test(@players[1].id, 0)
    end

    it 'does generate reinforcements for barbarians on turns divisible by 10' do
      stub_turns(10)
      perform_reinforcements_test(@players[1].id, 2)
    end
  end

  describe 'processing moves' do
    describe 'move unit' do
      before do
        @initial_game_state, @expected_game_state = GameStateLoader.parse 'spec/yml_states/test_move.yml'
      end

      it 'lets you move a unit to another city' do
        @initial_game_state.advance_turn(only: Skirmish::StateModifiers::Turn)

        success = @initial_game_state == @expected_game_state
        unless success
          states = [['initial', @initial_game_state], ['expected', @expected_game_state]]
          states.each do |state|
            puts "======== #{state[0]} units ========"
            unit_arrays = state[1].players.map(&:cities).flatten.map(&:units)
            unit_arrays.each do |units|
              p "-------- #{units[0].city.name} units -------"
              units.each do |unit|
                p unit
              end
              p '--------------------------------------------'
            end
            puts '==================================='
          end
        end

        expect(@initial_game_state).to eq(@expected_game_state)
      end
    end

    describe 'attack unit' do
      def perform_attack_test(yml_file, *turn_winners)
        @initial_game_state, @expected_game_state = GameStateLoader.parse yml_file

        stub_attacking_winning(*turn_winners)

        @initial_game_state.advance_turn(only: Skirmish::StateModifiers::Turn)

        success = @initial_game_state == @expected_game_state
        unless success
          states = [['initial', @initial_game_state], ['expected', @expected_game_state]]
          states.each do |state|
            puts "======== #{state[0]} units ========"
            unit_arrays = state[1].players.map(&:cities).flatten.map(&:units)
            unit_arrays.each do |units|
              p "-------- #{units[0].city.name} units -------"
              units.each do |unit|
                p unit
              end
              p '--------------------------------------------'
            end
            puts '==================================='
          end
        end

        expect(@initial_game_state).to eq(@expected_game_state)
      end

      it 'handles the attacker winning' do
        perform_attack_test('spec/yml_states/test_attack_attacker_wins.yml', true, true)
      end

      it 'handles the attacker losing' do
        perform_attack_test('spec/yml_states/test_attack_defender_wins.yml', false, false)
      end
    end
  end
end
