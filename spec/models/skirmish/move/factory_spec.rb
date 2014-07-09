require 'rails_helper'

describe Skirmish::Move::Factory do

  let(:user)          { instance_double('User', id: 3) }
  let(:player)        { instance_double('Skirmish::Player', id: 12) }
  let(:game_state)    { instance_double('Skirmish::GameState', game: true, get_city: city) }
  let(:units)         { [instance_double('Skirmish::Unit', id: 1), instance_double('Skirmish::Unit', id: 2)]}
  let(:city)          { instance_double('Skirmish::City', id: 1, units: units)}
  let(:move_json)     { { 'origin_ids' => [ 1, 2 ],
                          'quantity' => 2,
                          'action' => 'move_unit',
                          'origin_id' => 1,
                          'target_id' => 2} }
  let(:move_origins)  { double('MoveOrigins', new: true) }
  let(:skirmish_move) do
   double('Skirmish::Move',
     move_origins: move_origins,
     validate: [],
     save: true,
     origin_id: 1
   )
  end
  let(:args) do
    {
      move_json: move_json,
      game_id: '',
      user: user,
    }
  end

  before do
    allow(Skirmish::Player).to receive(:where) { [ player ] }
    allow(Skirmish::GameState).to receive(:from_game) { game_state }
    allow(Skirmish::Move).to receive(:new) { skirmish_move }
    allow(Skirmish::Turn).to receive(:add_move) { true }
  end

  it 'working' do
    move = Skirmish::Move::Factory.build(args)
    expect(move.save).to be(true)
  end

end
