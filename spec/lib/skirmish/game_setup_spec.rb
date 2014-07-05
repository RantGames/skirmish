require 'rails_helper'
require 'skirmish/factories'
require 'skirmish/game_setup'
require 'skirmish/city_list'

RSpec.describe 'setup player in game' do

  describe 'new game' do

    before do
      stub_model(Skirmish::Player)
      stub_model(Skirmish::Game)
      stub_model(Skirmish::City)
      @game = Skirmish::GameSetup.setup_new_game_state
    end

    it 'populates a game with one barbarian player' do
      players = @game.players
      expect(players.map(&:barbarian)).to eq([true])
      expect(players.map(&:name)).to eq([Skirmish::GameSetup::BARBARIAN_NAME])
    end

    pending it 'adds cities to game' do
      pattern = ''
      expect(@game.cities.to_json).to match_json_expression(pattern)
    end


  end

  describe 'setup in latest game' do



  end

end
