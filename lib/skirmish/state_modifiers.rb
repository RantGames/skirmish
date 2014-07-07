require 'skirmish/factories'

module Skirmish
  module StateModifiers
    class Reinforcements
      def self.process(match, game_state)
        cities = game_state.players.map(&:cities).flatten
        cities.map(&method(:add_reinforcement))

        game_state
      end

    private
      def self.add_reinforcement(city)
        city.units << Skirmish::Factories::Unit.make(city_id: city.id)
      end
    end

    class Turn
      def self.process(match, game_state)
        turn = match.turns.order('created_at DESC').limit(1).first
        turn.moves.each do |move|
          move.process(game_state)
        end
      end
    end

    class CheckForWin
      def self.process(game, game_state)
        return if game.player_count < 2
        potential_winner = game.cities.first.player
        if potential_winner.cities.length == game.cities.length
          game.winner = potential_winner
        end
      end
    end

  end
end
p Skirmish::StateModifiers

