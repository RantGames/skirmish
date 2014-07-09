require 'rails_helper'

RSpec.describe Skirmish::Player, :type => :model do
  it { should have_one :user }
  it { should have_many :cities }
  it { should have_many :moves }

  describe 'has_skipped?' do
    def perform_test(result, id)
      skips = [
          stub_model(Skirmish::Skip, player_id: 1),
      ]
      turn = double(:turn, skips: skips)
      game = double(:game)
      player = Skirmish::Player.new

      expect(Skirmish::Turn).to receive(:current_turn_for_game).with(game).and_return turn
      expect(player).to receive(:game).and_return game
      expect(player).to receive(:id).and_return id

      expect(player.has_skipped?).to eq(result)
    end

    it 'returns true if the player has skipped the current turn' do
      @id = 1
      @result = true
    end

    it 'returns false if the player has not skipped the current turn' do
      @id = 2
      @result = false
    end

    after do
      perform_test(@result, @id)
    end
  end
end
