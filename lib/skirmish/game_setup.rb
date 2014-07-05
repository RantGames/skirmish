module Skirmish::GameSetup

  def self.setup_new_game_state
    game = Skirmish::Game.new
    setup_barbarian(game)
  end

  def setup_in_latest_game

  end

  private

  def self.setup_barbarian(game)
    barbarian = Skirmish::Player.find_by_id(1) || Skirmish::Player.new(id:1)
    game.players << barbarian
    game
  end

end
