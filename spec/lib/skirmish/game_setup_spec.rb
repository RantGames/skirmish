require 'rails_helper'
require 'skirmish/factories'
require 'skirmish/game_setup'
require 'skirmish/city_list'

RSpec.describe 'setup player in game' do

  describe 'setup new game' do

    let(:citys) { [Skirmish::City.create(name:"Westport"), Skirmish::City.create(name:"Christchurch")] }

    before do
      stub_model(Skirmish::Player)
      stub_model(Skirmish::Game)
      stub_model(Skirmish::City)
      stub_model(Skirmish::Unit)
    end

    it 'populates a game with one barbarian player' do
      @game = Skirmish::GameSetup.setup_new_game_state
      @players = @game.players
      expect(@players.map(&:barbarian)).to eq([true])
      expect(@players.map(&:name)).to eq([Skirmish::GameSetup::BARBARIAN_NAME])
    end

    it 'adds cities to game' do
      allow(Skirmish::CityList).to receive(:random_cities).and_return(citys)
      allow(Skirmish::Factories::City).to receive(:make).and_return(citys)
      @game = Skirmish::GameSetup.setup_new_game_state
      @players = @game.players
      expect(@players[0].cities.map(&:name)).to eq(["Westport","Christchurch"])
    end

  end



end
