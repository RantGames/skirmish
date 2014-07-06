module Skirmish::BattleSimulator
  class BattleResult
    def initialize(attacker_won, defender_won)
      @defender_won = defender_won
      @attacker_won = attacker_won
    end

    def attacker_won?
      @attacker_won
    end

    def defender_won?
      @defender_won
    end
  end

  def self.resolve_battle(attacking_units, defending_city)
    until attacking_units.empty? || defending_city.units.empty?
      attacker_roll = rand(1..6)
      defender_roll = rand(1..6)
      if attacker_roll > defender_roll
        defending_city.units.first.destroy
      else
        attacking_units.first.destroy
      end
    end
    BattleResult.new(attacking_units.empty?, defending_city.units.empty?)
  end
end