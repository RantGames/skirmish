require 'rails_helper'

RSpec.describe Skirmish::Turn, :type => :model do
  it { should have_many :moves }
  it { should belong_to :game}

  describe 'get_current_turn_for_game' do
    it 'will give you the most recent uncompleted turn' do
      game = Skirmish::Game.create
      game.turns.create(completed: true)
      turn = game.turns.create

      expect(Skirmish::Turn.current_turn_for_game game).to eq(turn)
    end

    it 'will create a new turn if there are no uncompleted ones' do
      game = Skirmish::Game.create
      game.turns.create(completed: true)
      turn = stub_model Skirmish::Turn

      expect(Skirmish::Turn).to receive(:create).with(game_id: game.id).and_return turn
      expect(Skirmish::Turn.current_turn_for_game game).to eq(turn)
    end
  end
end
