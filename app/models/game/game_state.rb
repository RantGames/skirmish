require 'game/state_modifiers'

class Game::GameState
  attr_reader :players
  STATE_MODIFIERS = [Game::StateModifiers::Reinforcements]

  def initialize(players)
    @players = players
  end

  def advance_turn
    STATE_MODIFIERS.each do |modifier|
      modifier.process(self)
    end
  end

  def self.from_json(json)
    parser = GameStateParser.new(json)
    parser.parse
    GameState.new(parser.players)
  end

  def self.json_by_id(id)

  end
end
