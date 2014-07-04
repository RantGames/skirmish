require 'rails_helper'
require 'game/factories'

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

    @game_state = Skirmish::GameState.new(@players)
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
        @turn = Skirmish::Turn.create(game_id: @game.id)
        @turn.moves.create(player_id: @ubermouse.id, action: Skirmish::Move::MOVE_UNIT, origin_id: @copenhagen_unit.id, target_id: @wellington.id)
      end

      it 'lets you move a unit to another city' do
        @game_state.advance_turn(only: Skirmish::StateModifiers::Turn)

        copenhagen_units = @game_state.units_for_city(@copenhagen.id)
        wellington_units = @game_state.units_for_city(@wellington.id)

        expect(copenhagen_units.length).to eq(0)
        expect(wellington_units.first.id).to eq(@copenhagen_unit.id)
      end
    end
  end
end
