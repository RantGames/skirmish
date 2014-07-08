require 'rails_helper'

RSpec.describe Skirmish::Move, :type => :model do
  it { should belong_to :player }
  it { should belong_to :turn }
  it { should have_many :move_origins}

  describe 'target_id validation' do
    before do
      @stub = allow(Skirmish::City).to receive(:exists?).with(anything)
    end

    it 'validates if the city exists' do
      @stub.and_return true
      expect(Skirmish::Move.new(target_id: 1)).to be_valid
    end

    it 'does not validate if the city does not exist' do
      @stub.and_return false
      expect(Skirmish::Move.new(target_id: 2)).to have_exactly(1).error_on(:target_id)
    end
  end
end
