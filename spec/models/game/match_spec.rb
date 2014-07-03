require 'rails_helper'

RSpec.describe Game::Match, :type => :model do
  it { should have_many :players }
end
