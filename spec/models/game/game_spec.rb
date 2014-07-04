require 'rails_helper'

RSpec.describe Skirmish::Game, :type => :model do
  it { should have_many :players }
  it { should have_many :turns}
end

describe 'allocate match' do

  before do
    @match1 = Skirmish::Game.new
    @match1.players = [Skirmish::Factories::Player.make]

    allow(Skirmish::Game).to receive(:last).and_return(@match1)
  end

  context 'board not full' do

    it 'match has cities with no player id' do
      @match1.players.map(&:cities)[0][0].id = nil
      expect(@match1.not_full?).to eq(false)
    end

    it 'if board not full, send last board' do
      allow(@match1).to receive(:not_full?).and_return(true)
      expect(Skirmish::Game).to receive(:setup_in_latest_match)
      Skirmish::Game.allocate_game
    end

  end

  context 'board full' do

    it 'match has no cities with no player id' do
      expect(@match1.not_full?).to eq(true)
    end

    it 'if board full, setup_new_match' do
      allow(@match).to receive(:not_full?).and_return(false)
      expect(Skirmish::Game).to receive(:setup_new_game_state)
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