require 'game/state_modifiers'

class Game::GameState
  attr_reader :players
  attr_reader :match
  STATE_MODIFIERS = [Game::StateModifiers::Turn, Game::StateModifiers::Reinforcements]

  def initialize(players)
    @players = players
    match_id = players[0].match_id

    assert_match_ids_same(players, match_id)
    @match = Game::Match.find_by_id(match_id)
  end

  def advance_turn(only: nil)
    modifiers = STATE_MODIFIERS
    modifiers = filter_state_modifiers(modifiers, only)
    modifiers.each do |modifier|
      modifier.process(@match, self)
    end
  end


  def get_player(id)
    players.find {|p| p.id == id}
  end

  def get_city(city_id)
    cities = players.map(&:cities).flatten
    cities.find {|c| c.id == city_id}
  end

  def get_unit(unit_id)
    units = players.map(&:cities).flatten.map(&:units).flatten
    units.find {|u| u.id == unit_id}
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
    parser = GameStateParser.new(json)
    parser.parse
    GameState.new(parser.players)
  end

private
  def assert_match_ids_same(players, match_id)
    players.each do |p|
      if p.match_id != match_id
        raise "Not all players are in the same match (Culprit player #{p.id})"
      end
    end
  end

  def filter_state_modifiers(modifiers, only)
    modifiers = modifiers.select { |m| m.name == only.name } if only.present?
    modifiers
  end
end

