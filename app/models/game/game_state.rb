class Game::GameState

  def initialize(players)
    @players = players
  end

  def advance_turn

  end

  def self.from_json(json)
    parser = GameStateParser.new(json)
    parser.parse
    GameState.new(parser.players)
  end
end