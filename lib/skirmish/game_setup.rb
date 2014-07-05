module Skirmish::GameSetup

BARBARIAN_NAME = 'Neutral'
CITY_MIN_POPULATION = 150000
ANGLE_LAT_LONG = 10

  def self.setup_new_game_state
    game = Skirmish::Game.new
    setup_barbarian(game)
    setup_cities(game)
    game
  end

  def setup_in_latest_game

  end

  private

  def self.setup_barbarian(game)
    barbarian = Skirmish::Player.find_by_id(1) || Skirmish::Player.new(id:1, name:BARBARIAN_NAME)
    game.players << barbarian
    game
  end

  def self.setup_cities(game)
    city_list = Skirmish::CityList.random_cities(CITY_MIN_POPULATION,ANGLE_LAT_LONG)
    city_list.each do |city|
      game.cities << Skirmish::Factories::City.make({id:1,
                              name:city.name,
                              latitude: city.latitude,
                              longitude: city.longitude,
                              population: city.population
                              },1)
    end

  end



end
