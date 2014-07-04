class Skirmish::Game < ActiveRecord::Base
  has_many :players
  has_many :turns

  def self.allocate_game
    if self.exists? && !self.last.not_full?
      self.setup_in_latest_match
    else
      self.setup_new_game_state
    end
  end

  def not_full?
    self.cities.all? {|city| city.id != nil}
  end

  def cities
    self.players.map(&:cities).flatten
  end

  def self.setup_new_game_state
    # Game::GameState.new() - with player id? - sort out 2 player start issue
    self.setup_in_latest_match
  end

  def self.setup_in_latest_match
    # allocate user to randomly selected barbarian city(s)
  end

end
