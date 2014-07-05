dbrequire 'skirmish/factories'

game = Skirmish::Game.new

3.times do
  game.players << Skirmish::Factories::Player.make
end

game.save

