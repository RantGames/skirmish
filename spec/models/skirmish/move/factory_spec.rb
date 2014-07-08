require "rails_helper"

describe Skirmish::Move::Factory do

  let(:user)          { instance_double("User", id: 3) }
  let(:player)        { instance_double("Skirmish::Player", id: 12) }
  let(:game_state)    { instance_double("Skirmish::GameState", game: true) }
  let(:move_json)     { { "origin_ids" => [ 1, 2 ] } }
  let(:move_origins)  { double("MoveOrigins", new: true) }
  let(:skirmish_move) do
    instance_double("Skirmish::Move",
                    move_origins: move_origins,
                    validate: [],
                    save: true
                   )
  end
  let(:args) do
    {
      move_json: move_json,
      game_id: "",
      user: user,
    }
  end

  before do
    allow(Skirmish::Player).to receive(:where) { [ player ] }
    allow(Skirmish::GameState).to receive(:from_game) { game_state }
    allow(Skirmish::Move).to receive(:new) { skirmish_move }
    allow(Skirmish::Turn).to receive(:add_move) { true }
  end

  it "working" do
    move = Skirmish::Move::Factory.build(args)
    expect(move.save).to be(true)
  end

end
