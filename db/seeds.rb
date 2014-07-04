require "game/factories"

match = Game::Match.new

3.times do
  match.players << Game::Factories::Player.make
end

match.save

