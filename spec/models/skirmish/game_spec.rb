require 'rails_helper'
require 'skirmish/factories'
require 'skirmish/game_setup'

RSpec.describe Skirmish::Game, :type => :model do
  it { should have_many :players }
  it { should have_many :turns}

  describe 'join a user to a game' do

    let (:user) {double(:user, id:1, create_player: player)}
    let (:player) {Skirmish::Factories::Player.make}

    before do
      @game = Skirmish::Game.new
      @game.players = [Skirmish::Factories::Player.make]
      allow(Skirmish::Game).to receive(:last).and_return(@game)
    end

    describe '##join_new_game' do

      describe 'joining process' do

        before do
          allow(Skirmish::Game).to receive(:allocate_game).and_return(@game)
          allow(@game).to receive(:add_player)
        end

        it 'gets a game for the user to join' do
          expect(Skirmish::Game).to receive(:allocate_game)
        end

        it 'creates a player for the user' do
          expect(user).to receive(:create_player)
        end

        it 'adds the newly created player to the game' do
          expect(@game).to receive(:add_player).with(player)
        end

        after do
          Skirmish::Game.join_new_game(user)
        end
      end

      it 'returns the game with the user joined to it' do
        user = User.create(
            email: 'foo@bar.org',
            password: 'swordfish',
            password_confirmation: 'swordfish'
          )

        game = Skirmish::Game.join_new_game(user)
        expect(game.players.map(&:user)).to include user
      end

    end

    describe '##allocate_game' do
      context 'when the latest game has available spots' do
        before do
          allow(Skirmish::Game).to receive(:last_game_full?).and_return(false)
        end

        it 'gives the latest game' do
          allocated_game = Skirmish::Game.allocate_game
          expect(allocated_game).to eq @game
        end
      end
      context 'when the latest game is full' do
        before do
          allow(Skirmish::Game).to receive(:last_game_full?).and_return(true)
        end

        it 'returns a newly created game' do
          new_game = double :game
          expect(Skirmish::Game).to receive(:make).and_return new_game

          allocated_game = Skirmish::Game.allocate_game

          expect(allocated_game).to eq new_game
        end
      end
    end

    describe '##last_game_full?' do
      let(:game) { double :game, full?: result }
      let(:result) { double :result }

      it 'returns if the last game is full' do
        allow(Skirmish::Game).to receive(:last).and_return(game)

        expect(Skirmish::Game.last_game_full?).to eq result
      end

    end


    it 'creates a new game ready to be joined' do
      expect(Skirmish::GameSetup).to receive(:setup_new_game_state)
      Skirmish::Game.make
    end

  #   context 'when board isnt full' do

  #     it 'if game has bnarbarians ' do
  #       @game.cities.first.player.barbarian = true
  #       expect(@game.full?).to eq(false)
  #     end

  #     it 'if board not full, send last board' do
  #       allow(@game).to receive(:full?).and_return(false)
  #       expect(Skirmish::Game).to receive(:setup_in_latest_game)
  #       Skirmish::Game.allocate_game(1)
  #     end

  #   end

  #   context 'board full' do

  #     it 'all cities are not barbarians' do
  #       expect(@game.full?).to eq(true)
  #     end

  #     it 'if board full, setup_new_match' do
  #       allow(@game).to receive(:full?).and_return(true)
  #       expect(Skirmish::Game).to receive(:setup_new_game)
  #       Skirmish::Game.allocate_game(1)
  #     end

  #   end

  #   context 'no board' do

  #     it 'when no match, setup_new_match' do
  #       allow(@match).to receive(:exists?).and_return(false)
  #       expect(Skirmish::Game).to receive(:setup_new_game)
  #       Skirmish::Game.allocate_game(1)
  #     end

  #   end

  #   describe 'setup in latest game' do

  #     it 'adds current player to latest game' do
  #       stub_model(Skirmish::Game)
  #       allow(Skirmish::Game).to receive(:already_playing).and_return(false)
  #       expect(Skirmish::Game).to receive(:put_user_in_random_city)
  #       Skirmish::Game.allocate_game(1)
  #     end

  #     it ''




  #     pending it 'puts a user in a random starting city' do
  #       # stub_model(Skirmish::Cities)
  #       # stub_model(Skirmish::Player)

  #       latest_game = Skirmish::Game.create
  #       player = Skirmish::Player.create(barbarian:true)
  #       latest_game.players << player
  #       player.cities << Skirmish::City.create

  #       user_id = -10
  #       Skirmish::Game.setup_in_latest_game(user_id)



  #       expect().to eq(Skirmish::Game.last)

  #     end

  #   end

  end
end
