require 'rails_helper'

RSpec.describe Skirmish::Move, :type => :model do
  it { should belong_to :player }
  it { should belong_to :turn }
  it { should have_many :move_origins}
end
