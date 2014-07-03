require 'game/game_state_parser'
require 'rails_helper'
require 'game_state_helper'

describe GameStateParser do
  it 'can parse a game state' do
    game_state = {
        players: [
            {
                id: 1,
                name: 'ubermouse',
                cities: [
                    {
                        id: 1,
                        name: 'Copenhagen',
                        latitude: 55.6712674,
                        longitude: 12.5608388,
                        units: [
                            {
                                id: 1,
                                type: 'infantry',
                                attack: 1,
                                defense: 1
                            },
                            {
                                id: 2,
                                type: 'infantry',
                                attack: 1,
                                defense: 1
                            },
                        ]
                    }
                ]
            },
            {
                id: 2,
                name: 'widdershin',
                cities: [
                    {
                        id: 2,
                        name: 'Wellington',
                        latitude: -41.2443701,
                        longitude: 174.7618546,
                        units: [
                            {
                                id: 3,
                                unit_type: 'infantry',
                                attack: 1,
                                defense: 1
                            },
                            {
                                id: 4,
                                unit_type: 'infantry',
                                attack: 1,
                                defense: 1
                            },
                            {
                                id: 5,
                                unit_type: 'infantry',
                                attack: 1,
                                defense: 1
                            },
                        ]
                    }
                ]
            }
        ]
    }

    parser = GameStateParser.new(game_state.to_json)
    parser.parse

    ubermouse = Game::Player.new(id: 1, name: 'ubermouse')
    copenhagen = Game::City.new(id: 1, name: 'Copenhagen', latitude: 55.6712674, longitude: 12.5608388)
    copenhagen.units << GameStateHelper.make_infantry(1)
    copenhagen.units << GameStateHelper.make_infantry(2)

    widdershin = Game::Player.new(id: 2, name: 'Widdershin')
    wellington = Game::City.new(id: 3, name: 'Wellington', latitude: -41.2443701, longitude: 174.7618546)
    wellington.units << GameStateHelper.make_infantry(3)
    wellington.units << GameStateHelper.make_infantry(4)
    wellington.units << GameStateHelper.make_infantry(5)

    expect(parser.players).to eq([ubermouse, widdershin])
  end
end