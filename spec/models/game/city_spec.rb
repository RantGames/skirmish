require 'rails_helper'

RSpec.describe Game::City, :type => :model do
  it { should have_many :units }
  it { should belong_to :player }
end
