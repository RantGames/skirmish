require 'rails_helper'

describe Game::GameState do
  pending it 'can generate reinforcements' do
    ubermouse = Player.new(name: 'ubermouse')
    copenhagen_infantry = Unit.new(id: 1, type: 'infantry', attack: 1, defense: 1)
    copenhagen = City.new(name: 'Copenhagen', latitude: 1, longitude: 2)
    copenhagen.units << copenhagen_infantry

    widdershin = Player.new(name: 'widdershin')
    wellington_infantry = Unit.new(type: 'infantry', attack: 1, defense: 1)
    wellington = City.new(name: 'Wellington', latitude: 10, longitude: 20)
    wellington.units << wellington_infantry

    players = [ubermouse, widdershin]

    game_state = GameState.new(players)
    game_state.advance_turn

    updated_state = game_state.state
    expected_units = [Unit.new(type: 'infantry', attack: 1, defense: 1), Unit.new(type: 'infantry', attack: 1, defense: 1)]

    2.times do |i|
      expect(updated_state.players[i].cities[0].units).to eq(expected_units)
    end
  end

  pending it 'can convert game_state to json given id' do
    game_state_in_json = "{players:[{id:1,name:'ubermouse',cities:[{id:1,name:'Copenhagen',latitude:55.6712674,longitude:12.5608388,units:[{id:1,type:'infantry',attack:1,defense:1},{id:2,type:'infantry',attack:1,defense:1},]}]},{id:2,name:'widdershin',cities:[{id:2,name:'Wellington',latitude:-41.2443701,longitude:174.7618546,units:[{id:3,unit_type:'infantry',attack:1,defense:1},{id:4,unit_type:'infantry',attack:1,defense:1},{id:5,unit_type:'infantry',attack:1,defense:1},]}]}]}"

    expect(GameState.json_by_id(1)).to equal(game_state_in_json)

  end

end
