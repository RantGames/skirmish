require 'rails_helper'

RSpec.describe Skirmish::Game, :type => :model do
  it { should have_many :players }
  it { should have_many :turns}
end

describe 'allocate match' do

  before do
    @game = Skirmish::Game.new
    @game.players = [Skirmish::Factories::Player.make]
    allow(Skirmish::Game).to receive(:last).and_return(@game)
  end

  context 'board not full' do

    it 'game has cities with no player id' do
      @game.players.map(&:cities)[0][0].id = nil
      expect(@game.full?).to eq(false)
    end

    it 'if board not full, send last board' do
      allow(@game).to receive(:full?).and_return(false)
      Skirmish::Game.should_receive(:setup_in_latest_match)
      Skirmish::Game.allocate_game
    end

  end

  context 'board full' do

    it 'all cities have valid player ids' do
      expect(@game.full?).to eq(true)
    end

    it 'if board full, setup_new_match' do
      allow(@game).to receive(:full?).and_return(true)
      Skirmish::Game.should_receive(:setup_new_game_state)
      Skirmish::Game.allocate_game
    end

  end

  context 'no board' do

    it 'when no match, setup_new_match' do
      allow(@match).to receive(:exists?).and_return(false)
      expect(Skirmish::Game).to receive(:setup_new_game_state)
      Skirmish::Game.allocate_game
    end

  end

end
