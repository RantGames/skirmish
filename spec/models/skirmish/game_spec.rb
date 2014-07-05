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
      expect(@game.not_full?).to eq(true)
    end

    it 'if board not full, send last board' do
      allow(@game).to receive(:not_full?).and_return(true)
      Skirmish::Game.should_receive(:setup_in_latest_match)
      Skirmish::Game.allocate_game
    end

  end

  context 'board full' do

    it 'game has no cities with no player id' do
      expect(@game.not_full?).to eq(true)
    end

    it 'if board full, setup_new_match' do
      allow(@game).to receive(:not_full?).and_return(false)
      Skirmish::Game.should_receive(:setup_new_game_state)
      Skirmish::Game.allocate_game
    end

  end


end
