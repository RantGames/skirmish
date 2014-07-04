require 'rails_helper'

RSpec.describe Skirmish::Turn, :type => :model do
  it { should have_many :moves }
end
