require 'faker'

module Game
  module Factories
    class Unit
      def self.make(args = {})
        attributes = {
            id: rand(50000),
            unit_type: 'infantry',
            attack: 1,
            defense: 1
        }.merge(args)
        Game::Unit.new(attributes)
      end
    end


    class City
      def self.make(args = {}, num_units = 2)
        attributes = {
        id: rand(50000),
        name: Faker::Address.city,
        latitude: Faker::Address.latitude,
        longitude: Faker::Address.longitude,
        population: rand(2_500_000)
        }.merge(args)

        city = Game::City.new(attributes)
        num_units.times {
          city.units << Unit.make(city_id: city.id)
        }

        city
      end

    end

    class Player
      def self.make(args = {}, num_cities = 2, num_units_per_city = 2)
        attributes = {
            id: rand(50000),
            match_id: 1,
            name: Faker::Internet::user_name
        }.merge(args)

        player = Game::Player.new(attributes)
        num_cities.times {
          player.cities << City.make({player_id: player.id}, num_units_per_city)
        }

        player
      end
    end
  end
end
