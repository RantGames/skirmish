require 'rails_helper'

describe Game::GameState do
  it 'can generate reinforcements' do
    ubermouse = Game::Player.new(id: 1, name: 'ubermouse')
    copenhagen = Game::City.new(id: 1, name: 'Copenhagen', latitude: 1, longitude: 2)
    copenhagen.units.new(unit_type: 'infantry', attack: 1, defense: 1)
    ubermouse.cities << copenhagen

    widdershin = Game::Player.new(id: 2, name: 'widdershin')
    wellington = Game::City.new(id: 2, name: 'Wellington', latitude: 10, longitude: 20)
    wellington.units.new(unit_type: 'infantry', attack: 1, defense: 1)
    widdershin.cities << wellington

    players = [ubermouse, widdershin]

    game_state = Game::GameState.new(players)
    game_state.advance_turn

    2.times do |i|
      expected_units = [Game::Unit.new(city_id: i+1, unit_type: 'infantry', attack: 1, defense: 1),
                        Game::Unit.new(city_id: i+1, unit_type: 'infantry', attack: 1, defense: 1)]
      actual_units = game_state.players[i].cities[0].units.to_a
      actual_units.length.times {|i| expect(actual_units[i]).to be_same_as(expected_units[i])}
    end
  end
end