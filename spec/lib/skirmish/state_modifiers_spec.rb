require 'skirmish/game'
require 'skirmish/player'
require 'skirmish/state_modifiers'
require 'skirmish/factories'
require 'game_state_loader'

describe Skirmish::StateModifiers do

  describe 'Win checking' do
    it 'updates the game with a winner' do
      initial, expected, moves = GameStateLoader.parse 'spec/yml_states/test_for_win.yml'
      expect(initial.game.winner).to eq(nil)
      stub_attacking_winning(true)

      initial.advance_turn(only: [Skirmish::StateModifiers::Turn, Skirmish::StateModifiers::CheckForWin])

      expect(initial.game.winner).to eq(initial.players.first)
    end

    it 'does not let barbarians win' do
      initial, expected, moves = GameStateLoader.parse 'spec/yml_states/test_for_win.yml'
      initial.game.players.first.update_attributes(barbarian: true)

      initial.advance_turn(only: [Skirmish::StateModifiers::Turn, Skirmish::StateModifiers::CheckForWin])

      expect(initial.game.winner).to eq(nil)
    end
  end

  describe 'Reinforcements' do

  end

end
