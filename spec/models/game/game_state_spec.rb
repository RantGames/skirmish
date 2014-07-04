require 'rails_helper'
require 'game/factories'

describe Game::GameState do
  it 'can generate reinforcements' do
    ubermouse = Game::Player.new(id: 1, name: 'ubermouse')
    copenhagen = Game::City.new(id: 1, name: 'Copenhagen', latitude: 55.6712674, longitude: 12.5608388)
    copenhagen.units.new(unit_type: 'infantry', attack: 1, defense: 1)
    ubermouse.cities << copenhagen

    widdershin = Game::Player.new(id: 2, name: 'widdershin')
    wellington = Game::City.new(id: 2, name: 'Wellington', latitude: -41.2443701, longitude: 174.7618546)
    wellington.units.new(unit_type: 'infantry', attack: 1, defense: 1)
    widdershin.cities << wellington

    players = [ubermouse, widdershin]

    game_state = Game::GameState.new(players)
    game_state.advance_turn(only: Game::StateModifiers::Reinforcements)

    game_state.players.each_with_index do |player, i|
      expected_units = [Game::Unit.new(city_id: i+1, unit_type: 'infantry', attack: 1, defense: 1),
                        Game::Unit.new(city_id: i+1, unit_type: 'infantry', attack: 1, defense: 1)]
      actual_units = player.cities[0].units.to_a
      actual_units.zip(expected_units).each {|actual_unit, expected_unit| expect(actual_unit).to be_same_as(expected_unit)}
    end
  end

  pending it 'can convert game_state to json given id' do
    game_state_in_json = "{players:[{id:1,name:'ubermouse',cities:[{id:1,name:'Copenhagen',latitude:55.6712674,longitude:12.5608388,units:[{id:1,type:'infantry',attack:1,defense:1},{id:2,type:'infantry',attack:1,defense:1},]}]},{id:2,name:'widdershin',cities:[{id:2,name:'Wellington',latitude:-41.2443701,longitude:174.7618546,units:[{id:3,unit_type:'infantry',attack:1,defense:1},{id:4,unit_type:'infantry',attack:1,defense:1},{id:5,unit_type:'infantry',attack:1,defense:1},]}]}]}"
    expect(GameState.json_by_id(1)).to equal(game_state_in_json)

  end

  it 'can process a move turn' do
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
  end

end
