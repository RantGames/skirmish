require 'rails_helper'

RSpec.describe Skirmish::Player, :type => :model do
  it { should have_many :units }
  it { should have_many :cities }
end
