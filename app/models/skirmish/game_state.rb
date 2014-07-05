require 'game/state_modifiers'

class Skirmish::GameState
  attr_reader :players
  attr_reader :game
  STATE_MODIFIERS = [Skirmish::StateModifiers::Turn, Skirmish::StateModifiers::Reinforcements]

  def initialize(game)
    @game = game
    @players = game.players
  end

  def advance_turn(only: nil)
    modifiers = STATE_MODIFIERS
    modifiers = filter_state_modifiers(modifiers, only)
    modifiers.each do |modifier|
      modifier.process(@game, self)
    end
  end

  def get_player(id)
    Skirmish::Player.find_by_id(id)
  end

  def get_city(city_id)
    Skirmish::City.find_by_id(city_id)
  end

  def get_unit(unit_id)
    Skirmish::Unit.find_by_id(unit_id)
  end

  def cities_for_player(id)
    get_player(id).cities
  end

  def units_for_player(id)
    cities = get_player(id).cities
    cities.map(&:units).flatten
  end

  def units_for_city(city_id)
    city = get_city(city_id)
    city.units
  end

  def self.from_json(json)
    parser = Skirmish::GameStateParser.new(json)
    parser.parse
    GameState.new(parser.players)
  end

  def self.from_match(game_id)
    match = Game.find(game_id)
    Skirmish::GameState.new(match.players)
  end

private
  def assert_game_ids_same(players, game_id)
    players.each do |p|
      if p.game_id != game_id
        raise "Not all players are in the same match (Culprit player #{p.id})"
      end
    end
  end

  def filter_state_modifiers(modifiers, only)
    modifiers = modifiers.select { |m| m.name == only.name } if only.present?
    modifiers
  end
end

