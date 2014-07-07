require 'rails_helper'
require 'skirmish/factories'
require 'skirmish/game_setup'

RSpec.describe Skirmish::Game, :type => :model do
  it { should have_many :players }
  it { should have_many :turns}

  describe 'join a user to a game' do

    let (:user) {double(:user, id:1, create_player: player)}
    let (:player) {Skirmish::Factories::Player.make}
    let (:city) { @game.cities.first }

    before do
      @game = Skirmish::Game.new
      @game.players = [Skirmish::Factories::Player.make]
      allow(Skirmish::Game).to receive(:last).and_return(@game)
    end

    describe '##join_new_game' do

      describe 'joining process' do

        before do
          allow(Skirmish::Game).to receive(:allocate_game).and_return(@game)
          allow(@game).to receive(:award_random_barbarian_city).and_return(city)
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

        it 'awards a random starting city to the player' do
          expect(@game).to receive(:award_random_barbarian_city).with(player)
        end

        after do
          Skirmish::Game.join_new_game(user)
        end
      end

      describe 'returned game state' do
        let(:user) do
          User.create(
            email: 'foo@bar.org',
            password: 'swordfish',
            password_confirmation: 'swordfish'
          )
        end

        let(:game) { Skirmish::Game.join_new_game(user) }


        it 'returns the game with the user joined to it' do
          expect(game.players.map(&:user)).to include user
        end

        it 'returns the game with the user in a starting city' do
          expect(game.cities.map { |city| city.player.user } ).to include user
        end
      end

    end

    describe '##allocate_game' do
      context 'when the latest game has available spots' do
        before do
          allow(Skirmish::Game).to receive(:needs_new_game?).and_return(false)
        end

        it 'gives the latest game' do
          allocated_game = Skirmish::Game.allocate_game
          expect(allocated_game).to eq @game
        end
      end

      context 'when the latest game is full' do
        before do
          allow(Skirmish::Game).to receive(:needs_new_game?).and_return(true)
        end

        it 'returns a newly created game' do
          new_game = double :game
          expect(Skirmish::Game).to receive(:make).and_return new_game

          allocated_game = Skirmish::Game.allocate_game

          expect(allocated_game).to eq new_game
        end
      end

    end

    describe '##needs_new_game?' do
      let(:game) { double :game, full?: result }
      let(:result) { double :result }

      before do
        allow(Skirmish::Game).to receive(:last).and_return(game)
      end

      it 'returns true if there is no last game' do
        Skirmish::Game.stub_chain(:all, :empty?).and_return(true)
        expect(Skirmish::Game.needs_new_game?).to eq true
      end

      it 'returns true if the last game is full' do
        Skirmish::Game.stub_chain(:all, :empty?).and_return(false)
        expect(Skirmish::Game.needs_new_game?).to eq result
      end


    end

    describe '#award_random_barbarian_city' do
      it 'awards a random barbarian city to the player' do
        barbarian = Skirmish::Factories::Player.make(barbarian: true)
        player = Skirmish::Factories::Player.make({}, 0)

        @game.add_player barbarian

        @game.award_random_barbarian_city player
        expect(@game.cities.map(&:player)).to include player
      end
    end


    it 'creates a new game ready to be joined' do
      expect(Skirmish::GameSetup).to receive(:setup_new_game_state)
      Skirmish::Game.make
    end

  end

  describe 'winner' do

    it 'is false by default' do
      expect(Skirmish::Game.create.winner).to be_nil
    end

    it 'can be assigned' do
      winner = double(Skirmish::Player)
      game = Skirmish::Game.create
      game.winner = winner
      expect(game.winner).to eq(winner)
    end

  end

  describe 'factory make' do

    it 'has three players' do
      expect(Skirmish::Factories::Game.make.players.length).to eq(3)
    end

  end

end
