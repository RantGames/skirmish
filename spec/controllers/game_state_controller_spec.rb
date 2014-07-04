require 'rails_helper'
require 'game/factories'

RSpec.describe GameStateController, :type => :controller do

  describe 'show' do

    before do
      @game = Skirmish::Game.create
      @game.players = [Skirmish::Factories::Player.make]
      expect(Skirmish::Game).to receive(:find).and_return(@game)
      get 'show', :id => 1
    end

    describe "GET 'show'" do
      it 'returns http success' do
        expect(response).to be_success
      end

      it 'returns game_state in json' do
        pattern = {'game' =>{'id' =>wildcard_matcher, 'players' =>[{'id' =>Fixnum, 'name' =>String, 'cities' =>[{'id' =>Fixnum, 'name' =>String, 'latitude' =>Float, 'longitude' =>Float, 'population' =>Fixnum, 'units' =>[{'id' =>Fixnum, 'unit_type' =>String, 'attack' =>Fixnum, 'defense' =>Fixnum}, {'id' =>Fixnum, 'unit_type' =>String, 'attack' =>Fixnum, 'defense' =>Fixnum}]}, {'id' =>Fixnum, 'name' =>String, 'latitude' =>Float, 'longitude' =>Float, 'population' =>Fixnum, 'units' =>[{'id' =>Fixnum, 'unit_type' =>String, 'attack' =>Fixnum, 'defense' =>Fixnum}, {'id' =>Fixnum, 'unit_type' =>String, 'attack' =>Fixnum, 'defense' =>Fixnum}]}]}]}}
        expect(response.body).to match_json_expression(pattern)
      end

    end

    describe "GET 'new'" do

      before do
        @match = Game::Match.new
        @match.players = [Game::Factories::Player.make]
        @match.players[0].id = 5
        allow(Game::Match).to receive(:allocate_match).and_return(@match)
        get 'new'
      end

      it 'returns http success' do
        expect(response).to be_success
      end

      it 'gets a board for logged in player with their id in it' do
        pending('Skirmish::Game#setup_new_game_state needs to be implemented')
        expect(response.body).to include({id: @game.players.first.id}.to_json)
      end

    end

  end

end
