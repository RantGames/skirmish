class GameStateHelper
  def self.make_infantry(id)
    Game::Unit.new(id: id, unit_type: 'infantry', attack: 1, defense: 1)
  end
end