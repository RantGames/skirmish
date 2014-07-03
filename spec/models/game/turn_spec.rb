require 'rails_helper'

RSpec.describe Game::Turn, :type => :model do
  it { should have_many :moves }
end
