require 'rails_helper'
require 'skirmish/factories'
require 'json'
require 'pp'

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
        @user = User.create(
            email: 'foo@bar.org',
            password: 'swordfish',
            password_confirmation: 'swordfish'
          )
        sign_in(@user)
        get 'new'
      end

      it 'returns http success' do
        expect(response).to be_success
      end

      it 'gets a board for logged in player with their player_id in it' do
        game_state = JSON.parse(response.body)
        ids = game_state['game']['players'].map{|player| player['id']}
        expect(ids).to include(@user.player.id)
      end



    end

  end

end
