require 'skirmish/game'
require 'skirmish/player'
require 'skirmish/state_modifiers'
require 'skirmish/factories'
require 'game_state_loader'

describe Skirmish::StateModifiers::CheckForWin, focus: true do

  it 'updates the game with a winner' do
    initial, expected, moves = GameStateLoader.parse 'spec/yml_states/test_for_win.yml'
    expect(initial.game.winner).to eq(nil)

    initial.advance_turn(only: [Skirmish::StateModifiers::Turn, Skirmish::StateModifiers::CheckForWin])

    expect(initial.game.winner).to eq(initial.players.first)
  end

  it 'does not let barbarians win' do
    game = Skirmish::Factories::Game.make({}, 3)
    game.players.first.barbarian = true
    game.save
    game_state = Skirmish::GameState.from_game(game)

    game_state.advance_turn(only: [Skirmish::StateModifiers::Turn, Skirmish::StateModifiers::CheckForWin])

    expect(game_state.game.winner).to eq(nil)
  end

end
