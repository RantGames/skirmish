require 'rails_helper'
require 'game/factories'

describe Game::GameState do

  before do
    @match = Game::Match.create(id: 1)

    @ubermouse = Game::Player.create(match_id: @match.id, name: 'ubermouse')
    @copenhagen = Game::City.create(name: 'Copenhagen', latitude: 55.6712674, longitude: 12.5608388)
    @copenhagen_unit = Game::Unit.create(unit_type: 'infantry', attack: 1, defense: 1)
    @copenhagen.units << @copenhagen_unit
    @ubermouse.cities << @copenhagen
    @wellington = Game::City.create(name: 'Wellington', latitude: -41.2443701, longitude: 174.7618546)
    @ubermouse.cities << @wellington
    @players = [@ubermouse, Game::Factories::Player.make]

    @game_state = Game::GameState.new(@players)
  end

  describe 'advancing a turn' do

    it 'generates reinforcements' do
      p1_id = @players[0].id
      cities = @game_state.cities_for_player(p1_id)

      expect {
        @game_state.advance_turn(only: Game::StateModifiers::Reinforcements)
      }.to change {
        @game_state.units_for_player(p1_id).length
      }.by(cities.length)
    end
  end

  describe 'processing moves' do
    describe 'move unit' do
      before do
        @turn = Game::Turn.create(match_id: @match.id)
        @turn.moves.create(player_id: @ubermouse.id, action: Game::Move::MOVE_UNIT, origin_id: @copenhagen_unit.id, target_id: @wellington.id)
      end

      it 'lets you move a unit to another city' do
        @game_state.advance_turn(only: Game::StateModifiers::Turn)

        copenhagen_units = @game_state.units_for_city(@copenhagen.id)
        wellington_units = @game_state.units_for_city(@wellington.id)

        expect(copenhagen_units.length).to eq(0)
        expect(wellington_units.first.id).to eq(@copenhagen_unit.id)
      end
    end
  end
end
