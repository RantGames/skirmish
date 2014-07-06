require 'rails_helper'
require 'skirmish/factories'

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

  pending it 'can convert game_state to json given id' do
    game_state_in_json = "{players:[{id:1,name:'ubermouse',cities:[{id:1,name:'Copenhagen',latitude:55.6712674,longitude:12.5608388,units:[{id:1,type:'infantry',attack:1,defense:1},{id:2,type:'infantry',attack:1,defense:1},]}]},{id:2,name:'widdershin',cities:[{id:2,name:'Wellington',latitude:-41.2443701,longitude:174.7618546,units:[{id:3,unit_type:'infantry',attack:1,defense:1},{id:4,unit_type:'infantry',attack:1,defense:1},{id:5,unit_type:'infantry',attack:1,defense:1},]}]}]}"
    expect(GameState.json_by_id(1)).to equal(game_state_in_json)

  end

  pending it 'can process a move turn' do
    ubermouse = Game::Player.new(id: 1, name: 'ubermouse')
    copenhagen = Game::City.new(id: 1, name: 'Copenhagen', latitude: 55.6712674, longitude: 12.5608388)
    copenhagen.units.new(id: 1, unit_type: 'infantry', attack: 1, defense: 1)
    ubermouse.cities << copenhagen
    wellington = Game::City.new(id: 2, name: 'Wellington', latitude: -41.2443701, longitude: 174.7618546)
    ubermouse.cities << wellington

    game_state = Game::GameState.new([ubermouse, Game::Factories::Player.make])
    Game::Move.create(player_id: ubermouse.id, action: Game::Move::MOVE_UNIT, origin_id: 1, target_id: copenhagen.id)
    game_state.advance_turn(only: Game::StateModifiers::Turn)

    copenhagen_units = game_state.units_for_city(copenhagen.id)
    wellington_units = game_state.units_for_city(wellington.id)

    expect(copenhagen_units.length).to eq(0)
    expect(wellington_units.first.id).to eq(1)
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
        move = Skirmish::Move.new(player_id: @ubermouse.id, action: Skirmish::Move::MOVE_UNIT, target_id: @wellington.id)
        move.move_origins.new(origin_id: @copenhagen_unit.id)
        @turn.moves << move
      end

      it 'lets you move a unit to another city' do
        @game_state.advance_turn(only: Skirmish::StateModifiers::Turn)

        copenhagen_units = @game_state.units_for_city(@copenhagen.id)
        wellington_units = @game_state.units_for_city(@wellington.id)

        expect(copenhagen_units.length).to eq(0)
        expect(wellington_units.first.id).to eq(@copenhagen_unit.id)
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
