require 'rails_helper'

RSpec.describe Push, :type => :service do
  it 'sends message out through pusher to pull game state' do
    push = Push.new
    expect(Pusher).to receive(:trigger).with('skirmish_channel','update_state', { message: 'pull_game_state'})
    push.push_state_notice
  end
end

