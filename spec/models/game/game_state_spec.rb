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

  it 'can process a move turn' do
    match = Game::Match.create(id: 1)

    ubermouse = Game::Player.create(match_id: match.id, name: 'ubermouse')
    copenhagen = Game::City.create(name: 'Copenhagen', latitude: 55.6712674, longitude: 12.5608388)
    copenhagen_unit = Game::Unit.create(unit_type: 'infantry', attack: 1, defense: 1)
    copenhagen.units << copenhagen_unit
    ubermouse.cities << copenhagen
    wellington = Game::City.create(name: 'Wellington', latitude: -41.2443701, longitude: 174.7618546)
    ubermouse.cities << wellington

    game_state = Game::GameState.new([ubermouse, Game::Factories::Player.make])
    turn = Game::Turn.create(match_id: match.id)
    turn.moves.create(player_id: ubermouse.id, action: Game::Move::MOVE_UNIT, origin_id: copenhagen_unit.id, target_id: wellington.id)
    game_state.advance_turn(only: Game::StateModifiers::Turn)

    copenhagen.reload

    copenhagen_units = game_state.units_for_city(copenhagen.id)
    wellington_units = game_state.units_for_city(wellington.id)

    expect(copenhagen_units.length).to eq(0)
    expect(wellington_units.first.id).to eq(copenhagen_unit.id)
  end
end
