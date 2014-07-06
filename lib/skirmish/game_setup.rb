require 'skirmish/factories'
require 'skirmish/city_list'


module Skirmish::GameSetup

  BARBARIAN_NAME = 'Neutral'
  CITY_MIN_POPULATION = 150000
  ANGLE_LAT_LONG = 10
  DEFAULT_UNIT_QUANTITY = 1

  def self.setup_new_game_state
    game = Skirmish::Game.new
    barbarian = add_new_barbarian(game)
    setup_cities(barbarian)
    game.save
    game
  end

  private

  def self.add_new_barbarian(game)
    barbarian = Skirmish::Player.create({
      name:BARBARIAN_NAME,
      barbarian:true })
    game.players << barbarian
    barbarian
  end

  def self.setup_cities(barbarian)
    city_list = Skirmish::CityList.random_cities(CITY_MIN_POPULATION,ANGLE_LAT_LONG)

    city_list.each do |city|
      barbarian.cities << Skirmish::Factories::City.make(
        {
          name:city.name,
          latitude: city.latitude,
          longitude: city.longitude,
          population: city.population
        }, DEFAULT_UNIT_QUANTITY
      )
    end

  end



end
