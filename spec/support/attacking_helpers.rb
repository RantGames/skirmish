module AttackingHelpers
  def stub_attacking_winning(*winners)
    allow(Skirmish::BattleSimulator).to receive(:check_winner).with(Integer, Integer).and_return(*winners)
  end
end