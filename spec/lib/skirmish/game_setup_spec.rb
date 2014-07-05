require 'rails_helper'
require 'skirmish/factories'
require 'skirmish/game_setup'

RSpec.describe 'setup player in game' do

  describe 'new game' do

    it 'populates a game with one barbarian player' do
      game = Skirmish::GameSetup.setup_new_game_state
      expect(game.players.map(&:id)).to eq([1])
    end



  end





  describe 'setup in latest game' do



  end

end
