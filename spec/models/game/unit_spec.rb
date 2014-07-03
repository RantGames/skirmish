require 'rails_helper'

RSpec.describe Game::Unit, :type => :model do
  it { should belong_to :city }
  it { should belong_to :player }
end
