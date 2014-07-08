require 'skirmish/factories'

module Skirmish
  module StateModifiers
    class Reinforcements
      def self.process(game_state)
        barbarian, *humans = game_state.players.order('barbarian DESC')

        cities = humans.map(&:cities).flatten
        cities.select{|c| occupied_for_two_turns(c, game_state)}.each(&method(:add_reinforcement))

        handle_barbarian(game_state.game, barbarian)
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

      def self.occupied_for_two_turns(city, game_state)
        if city.occupied_turn == nil
          true
        else
          (game_state.turn_number - city.occupied_turn) >= 2
        end
      end
    end

    class Turn
      def self.process(game_state)
        turn = Skirmish::Turn.current_turn_for_game game_state.game
        turn.moves.each do |move|
          move.process(game_state)
        end
      end
    end

    class CheckForWin
      #todo players cities state is stale, but count hits the database so it's unaffected
      def self.process(game_state)
        all_cities = game_state.players.map(&:cities).flatten
        cities_to_win = all_cities.count * 0.8
        game = game_state.game
        game.players.select{|p| not p.barbarian}.each do |p|
          if p.cities.count >= cities_to_win
            game.winner = p
            break
          end
        end
      end
    end

  end
end


