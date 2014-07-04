require 'game/game_state_parser'
require 'game/factories'
require 'rails_helper'

describe Skirmish::GameStateParser do
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
                        population: 1_969_941,
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
                        population: 200_000,
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

    parser = Skirmish::GameStateParser.new(game_state.to_json)
    parser.parse

    ubermouse = Skirmish::Player.new(id: 1, name: 'ubermouse')
    copenhagen = Skirmish::City.new(id: 1, name: 'Copenhagen', latitude: 55.6712674, longitude: 12.5608388)
    copenhagen.units << Skirmish::Factories::Unit.make(id: 1)
    copenhagen.units << Skirmish::Factories::Unit.make(id: 2)

    widdershin = Skirmish::Player.new(id: 2, name: 'Widdershin')
    wellington = Skirmish::City.new(id: 3, name: 'Wellington', latitude: -41.2443701, longitude: 174.7618546)
    wellington.units << Skirmish::Factories::Unit.make(id: 3)
    wellington.units << Skirmish::Factories::Unit.make(id: 4)
    wellington.units << Skirmish::Factories::Unit.make(id: 5)

    expect(parser.players).to eq([ubermouse, widdershin])
  end
end
