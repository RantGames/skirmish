require 'game/factories'

module Game
  module StateModifiers
    class Reinforcements
      def self.process(game_state)
        cities = game_state.players.map(&:cities).flatten
        cities.map(&method(:add_reinforcement))

        game_state
      end

    private
      def self.add_reinforcement(city)
        city.units << Game::Factories::Unit.make(city_id: city.id)
      end
    end
  end
end