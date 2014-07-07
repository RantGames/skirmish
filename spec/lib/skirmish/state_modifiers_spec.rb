require 'skirmish/game'
require 'skirmish/player'
require 'skirmish/state_modifiers'
require 'skirmish/factories'

RSpec.describe Skirmish::StateModifiers::CheckForWin do

  before do
    @game = Skirmish::Factories::Game.make
    @winner = @game.players.last
    cities = @game.cities
    cities.each {|city| city.player = @winner; city.save}
  end

  it 'update the game with winner' do
    Skirmish::StateModifiers::CheckForWin.process(@game, nil)
    expect(@game.winner).to eq(@winner)
  end

  it 'starter board has no winner' do
    new_game = Skirmish::Game.make
    Skirmish::StateModifiers::CheckForWin.process(new_game, nil)
    expect(new_game.winner).to be_nil
  end

end
