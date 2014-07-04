require 'rails_helper'
require 'game/factories'

RSpec.describe GameStateController, :type => :controller do

  before do
    @match = Game::Match.new
    3.times do
      @match.players << Game::Factories::Player.make
    end
    Game::Match.stub(:find).and_return(@match)
    get 'show', :id => 1
  end

  describe "GET 'show'" do
    it "returns http success" do
      expect(response).to be_success
    end
  end

  describe "GET show a match by id" do

    it "returns game_state in json" do
      p response.body
      expect(response.body).to eq(@match.to_json)
    end

  end

end
