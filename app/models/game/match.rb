class Game::Match < ActiveRecord::Base
  has_many :players
  has_many :turns

  def self.allocate_match
    self.setup_new_game_state if self.last.full?
    self.setup_in_latest_match
  end

  def full?
    self.cities.all? {|city| city.id != nil}
  end

  def cities
    self.players.map(&:cities).flatten
  end

  def self.setup_new_game_state
    # Game::GameState.new() - with player id - sort out 2 player start issue
  end

  def self.setup_in_latest_match
    # allocate user to randomly selected barbarian city(s)
  end

end
