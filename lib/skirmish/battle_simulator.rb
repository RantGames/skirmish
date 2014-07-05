class Skirmish::BattleSimulator
  def self.resolve_battle(attacking_unit, defending_unit)
    if rand(1..2) == 1
      attacking_unit
    else
      defending_unit
    end
  end
end