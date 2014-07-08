require 'rails_helper'

RSpec.describe Skirmish::MoveOrigin, :type => :model do
  it { should belong_to :move }

  describe 'origin_id validation' do
    before do
      @stub = allow(Skirmish::Unit).to receive(:exists?).with(anything)
    end

    it 'validates if the unit exists' do
      @stub.and_return true
      expect(Skirmish::MoveOrigin.new(origin_id: 1)).to be_valid
    end

    it 'does not validate if the unit does not exist' do
      @stub.and_return false
      expect(Skirmish::MoveOrigin.new(origin_id: 2)).to have_exactly(1).errors_on(:origin_id)
    end
  end
end
