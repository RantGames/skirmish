require 'rails_helper'

describe Game::GameState do
  it 'can generate reinforcements' do
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
end