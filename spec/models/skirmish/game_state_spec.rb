require 'rails_helper'
require 'skirmish/factories'
require 'game_state_loader'

describe Skirmish::GameState do

  before do
    @game = Skirmish::Game.create(id: 1)

    @ubermouse = Skirmish::Player.create(game_id: @game.id, name: 'ubermouse')
    @copenhagen = Skirmish::City.create(name: 'Copenhagen', latitude: 55.6712674, longitude: 12.5608388)
    @copenhagen_unit = Skirmish::Unit.create(unit_type: 'infantry', attack: 1, defense: 1)
    @copenhagen.units << @copenhagen_unit
    @ubermouse.cities << @copenhagen
    @wellington = Skirmish::City.create(name: 'Wellington', latitude: -41.2443701, longitude: 174.7618546)
    @ubermouse.cities << @wellington
    @players = [@ubermouse, Skirmish::Factories::Player.make]
    @game.players = @players

    @game_state = Skirmish::GameState.new(@game)
  end

  describe 'advancing a turn' do

    it 'generates reinforcements' do
      p1_id = @players[0].id
      cities = @game_state.cities_for_player(p1_id)

      expect {
        @game_state.advance_turn(only: Skirmish::StateModifiers::Reinforcements)
      }.to change {
        @game_state.units_for_player(p1_id).length
      }.by(cities.length)
    end
  end

  describe 'processing moves' do
    describe 'move unit' do
      before do
        @initial_game_state, @expected_game_state = GameStateLoader.parse 'spec/yml_states/test_move.yml'
      end

      it 'lets you move a unit to another city' do
        @initial_game_state.advance_turn(only: Skirmish::StateModifiers::Turn)
        expect(@initial_game_state).to eq(@expected_game_state)
      end
    end

    describe 'attack unit' do
      before do
        @enemy_city = @game.players.last.cities.first
        @turn = Skirmish::Turn.create(game_id: @game.id)
        move = Skirmish::Move.new(player_id: @ubermouse.id, action: Skirmish::Move::ATTACK_UNIT, target_id: @enemy_city.id)
        move.move_origins.new(origin_id: @copenhagen_unit.id)
        @turn.moves << move
      end

      it 'attacks a targeted enemy unit and destroys either your unit or the enemy unit' do
        @game_state.advance_turn(only: Skirmish::StateModifiers::Turn)

        expect(@game_state.get_city(@enemy_city.id).units.empty? || @game_state.get_unit(@copenhagen_unit.id) == nil).to eq(true)
      end
    end
  end
end
