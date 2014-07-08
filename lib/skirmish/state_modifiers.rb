require 'skirmish/factories'

module Skirmish
  module StateModifiers
    class Reinforcements
      def self.process(game, game_state)
        barbarian, *humans = game.players.order('barbarian DESC')

        cities = humans.map(&:cities).flatten
        cities.each(&method(:add_reinforcement))

        handle_barbarian(game, barbarian)

        game_state
      end


    private
      def self.add_reinforcement(city)
        city.units << Skirmish::Factories::Unit.make(city_id: city.id)
      end

      def self.handle_barbarian(game, barbarian)
        # todo tweak this, there is probably a more appropriate value
        if game.turns.count % 10 == 0
          barbarian.cities.each(&method(:add_reinforcement))
        end
      end
    end

    class Turn
      def self.process(game, game_state)
        turn = Skirmish::Turn.current_turn_for_game game_state.game
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


