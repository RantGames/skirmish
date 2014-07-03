class GameStateParser
  attr_accessor :players

  def initialize(json)
    @players = nil
    @json = JSON.parse(json)
  end

  def parse
    @players = @json['players'].map(&method(:parse_player))
  end

private
  def parse_player(player_hash)
    player = Game::Player.new(id: player_hash['id'], name: player_hash['name'])
    cities = player_hash['cities'].map(&method(:parse_city))
    player.cities = cities

    player
  end

  def parse_city(city_hash)
    city = Game::City.new(id: city_hash['id'],
                          name: city_hash['name'],
                          latitude: city_hash['latitude'],
                          longitude: city_hash['longitude'],
                          population: city_hash['population'])
    units = city_hash['units'].map(&method(:parse_unit))
    city.units = units

    city
  end

  def parse_unit(unit)
    Game::Unit.new(id: unit['id'], unit_type: unit['unit_type'], attack: unit['attack'], defense: unit['defense'])
  end
end