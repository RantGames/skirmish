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
      attacker_roll = Random.rand(1..6)
      defender_roll = Random.rand(1..6)
      if attacker_roll > defender_roll
        defending_city.units.first.destroy
        defending_city.units = defending_city.units.drop 1
      else
        attacking_units.first.destroy
        attacking_units = attacking_units.drop 1
      end
    end
    BattleResult.new(defending_city.units.empty?, attacking_units.empty?)
  end
end