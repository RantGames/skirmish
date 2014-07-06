require 'rails_helper'

RSpec.describe ClientNotifier, :type => :service do
  it 'sends message out through pusher to pull game state' do
    expect(Pusher).to receive(:trigger).with('skirmish_channel','update_state', { message: 'pull_game_state'})
    ClientNotifier.push_state_notice
  end
end

