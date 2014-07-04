require 'rails_helper'
require 'game/factories'

RSpec.describe GameStateController, :type => :controller do

  before do
    @match = Game::Match.new
    @match.players = [Game::Factories::Player.make]
    Game::Match.stub(:find).and_return(@match)
    get 'show', :id => 1
  end

  describe "GET 'show'" do
    it "returns http success" do
      expect(response).to be_success
    end
  end

  describe "GET get json match by id" do

    it "returns game_state in json" do
      pattern = {"match"=>{"id"=>wildcard_matcher, "players"=>[{"id"=>Fixnum, "name"=>String, "cities"=>[{"id"=>Fixnum, "name"=>String, "latitude"=>Float, "longitude"=>Float, "population"=>Fixnum, "units"=>[{"id"=>Fixnum, "unit_type"=>String, "attack"=>Fixnum, "defense"=>Fixnum}, {"id"=>Fixnum, "unit_type"=>String, "attack"=>Fixnum, "defense"=>Fixnum}]}, {"id"=>Fixnum, "name"=>String, "latitude"=>Float, "longitude"=>Float, "population"=>Fixnum, "units"=>[{"id"=>Fixnum, "unit_type"=>String, "attack"=>Fixnum, "defense"=>Fixnum}, {"id"=>Fixnum, "unit_type"=>String, "attack"=>Fixnum, "defense"=>Fixnum}]}]}]}}
      expect(response.body).to match_json_expression(pattern)
    end

  end

end
