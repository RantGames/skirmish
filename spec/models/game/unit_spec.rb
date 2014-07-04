require 'rails_helper'

RSpec.describe Skirmish::Unit, :type => :model do
  it { should belong_to :city }
  it { should belong_to :player }
end
