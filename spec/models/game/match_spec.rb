require 'rails_helper'

RSpec.describe Skirmish::Game, :type => :model do
  it { should have_many :players }
end

describe 'allocate match' do

  before do
    @match1 = Skirmish::Game.new
    @match1.players = [Skirmish::Factories::Player.make]

    Skirmish::Game.stub(:last).and_return(@match1)
  end

  context 'board not full' do

    it 'match has cities with no player id' do
      @match1.players.map(&:cities)[0][0].id = nil
      expect(@match1.full?).to eq(false)
    end

    it 'if board not full, send last board' do
      @match1.stub(:full?).and_return(false)
      Skirmish::Game.should_receive(:setup_in_latest_match)
      Skirmish::Game.allocate_game
    end

  end

  context 'board full' do

    it 'match has no cities with no player id' do
      expect(@match1.full?).to eq(true)
    end

    it 'if board full, setup_new_match' do
      @match1.stub(:full?).and_return(true)
      Skirmish::Game.should_receive(:setup_new_game_state)
      Skirmish::Game.allocate_game
    end

  end


end
