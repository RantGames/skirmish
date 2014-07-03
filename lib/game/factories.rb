module Game
  module Factories
    class Unit
      def self.make(args)
        attributes = {
            unit_type: 'infantry',
            attack: 1,
            defense: 1
        }.merge(args)
        Game::Unit.new(attributes)
      end
    end
  end
end