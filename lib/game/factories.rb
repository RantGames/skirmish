require 'faker'

module Skirmish
  module Factories
    class Unit
      def self.make(args = {})
        attributes = {
            unit_type: 'infantry',
            attack: 1,
            defense: 1
        }.merge(args)
        Skirmish::Unit.create(attributes)
      end
    end


    class City
      def self.make(args = {}, num_units = 2)
        attributes = {
        name: Faker::Address.city,
        latitude: Faker::Address.latitude,
        longitude: Faker::Address.longitude,
        population: rand(2_500_000)
        }.merge(args)

        city = Skirmish::City.create(attributes)
        num_units.times {
          city.units << Unit.make(city_id: city.id)
        }

        city.save
        city
      end

    end

    class Player
      def self.make(args = {}, num_cities = 2, num_units_per_city = 2)
        attributes = {
            match_id: 1,
            name: Faker::Internet::user_name
        }.merge(args)

        player = Skirmish::Player.create(attributes)
        num_cities.times {
          player.cities << City.make({player_id: player.id}, num_units_per_city)
        }

        player.save
        player
      end
    end
  end
end
