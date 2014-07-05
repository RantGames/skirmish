require 'rails_helper'

RSpec.describe Skirmish::Player, :type => :model do
  it { should belong_to :user }
  it { should have_many :cities }
  it { should have_many :moves }
end
