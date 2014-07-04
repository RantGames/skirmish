require "game/factories"

match = Skirmish::Game.new

3.times do
  match.players << Skirmish::Factories::Player.make
end

match.save

