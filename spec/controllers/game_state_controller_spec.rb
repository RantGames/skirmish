require 'rails_helper'
require 'skirmish/factories'
require 'json'
require 'pp'

RSpec.describe GameStateController, :type => :controller do

  describe 'show' do
    let(:user) {
      User.create(
          email: 'foo@bar.org',
          password: 'swordfish',
          password_confirmation: 'swordfish'
      )
    }


    before do
      @game = Skirmish::Game.create
      @game.players = [Skirmish::Factories::Player.make]
      allow(Skirmish::Game).to receive(:find).and_return(@game)
    end

    describe "GET 'show'" do

      before do
        allow(user).to receive(:current_game).and_return(@game)
        sign_in(user)
        get 'show'
      end

      it 'returns http success' do
        expect(response).to be_success
      end

      it 'returns game_state in json' do
        pattern = {
            game: {
                id: Fixnum,
                winner: wildcard_matcher,
                players: [
                    {
                      id: Fixnum,
                      name: String,
                      user_id: wildcard_matcher,
                      gravatar_hash: String,
                      cities: [
                          {
                            id: Fixnum,
                            name: String,
                            latitude: Float,
                            longitude: Float,
                            population: Fixnum,
                            units: [
                                {id: Fixnum, unit_type: String, attack: Fixnum, defense: Fixnum},
                                {id: Fixnum, unit_type: String, attack: Fixnum, defense: Fixnum}]
                          },
                          {
                            id: Fixnum,
                            name: String,
                            latitude: Float,
                            longitude: Float,
                            population: Fixnum,
                            units: [
                                {id: Fixnum, unit_type: String, attack: Fixnum, defense: Fixnum},
                                {id: Fixnum, unit_type: String, attack: Fixnum, defense: Fixnum}]
                          }]
                    }]
            }
        }
        expect(response.body).to match_json_expression(pattern)
      end

    end

    describe "GET 'new'" do
      let(:user) {User.create(
          email: 'foo@bar.org',
          password: 'swordfish',
          password_confirmation: 'swordfish'
        )}


      context 'gets new game state' do

        before do
          Skirmish::Game.destroy_all
          sign_in(user)
          get 'new'
        end

        it 'returns http success' do
          expect(response).to be_success
        end

        it 'gets a board for logged in user with a new player_id in it' do
          game_state = JSON.parse(response.body)
          ids = game_state['game']['players'].map{|player| player['id']}
          expect(ids).to include(user.players.last.id)
        end

      end

      context 'doesnt get new game state' do

        it 'returns error if user already in game' do
          sign_in(user)
          allow(Skirmish::Game).to receive(:is_user_in_latest_game?).with(user).and_return(true)
          get 'new'
          expect(response).to be_forbidden
        end

      end

    end

  end


  describe "GET new" do
    before do
      user = instance_double("User")
      allow(controller).to receive(:authenticate_user!) { true }
      allow(controller).to receive(:current_user) { user }
    end

    context "when user is already in the game" do
      before { allow(Skirmish::Game).to receive(:is_user_in_latest_game?) { true } }

      it "returns a forbidden status" do
        get "new"
        expect(response).to be_forbidden
      end
    end

    context "when user is not already in the game" do
      before { allow(Skirmish::Game).to receive(:is_user_in_latest_game?) { false } }

      it "returns json for the current game" do
        fake_data = { game_id: 3 }
        allow(Skirmish::Game).to receive(:join_new_game) { fake_data }
        get "new"
        expect(response.body).to include(fake_data.to_json)
      end
    end
  end

  describe "GET show" do
    let(:user) { instance_double("User") }

    before do
      allow(controller).to receive(:authenticate_user!) { true }
      allow(controller).to receive(:current_user) { user }
    end

    context "when user is already in a game" do
      before { allow(user).to receive(:is_in_a_game?) { true } }

      it "returns json for the current game" do
        fake_data = { game_id: 3 }
        allow(user).to receive(:current_game) { fake_data }
        get "show"
        expect(response.body).to include(fake_data.to_json)
      end
    end

    context "when user is not already in a game" do
      before { allow(user).to receive(:is_in_a_game?) { false } }

      it "returns a forbidden status" do
        get "show"
        expect(response).to be_forbidden
      end
    end
  end

end
