class Skirmish::Game < ActiveRecord::Base
  has_many :players, class_name: 'Skirmish::Player'
  has_many :turns

  def self.join_new_game(user)
    player = user.create_player

    game = allocate_game
    game.add_player player
    game
  end

  def self.make
    Skirmish::GameSetup.setup_new_game_state
  end

  def create_player_for_user(user)
    # player = user.player.create
  end

  def add_player(player)
    self.players << player
  end

  def self.last_game_full?
    last.full?
  end


  def self.allocate_game
    if last_game_full?
      Skirmish::Game.make
    else
      Skirmish::Game.last
    end
  end

  def full?
    self.cities.all? {|city| !city.player.barbarian}
  end

  def cities
    self.players.map(&:cities).flatten
  end

  # def self.setup_new_game(user_id)
  #   Skirmish::GameSetup.setup_new_game_state
  #   self.setup_in_latest_game(user_id)
  # end

  # def self.setup_in_latest_game(user_id)
  #   latest = Skirmish::Game.last
  #   put_user_in_random_city(latest, user_id) if not_playing?(latest, user_id)
  #   latest
  # end

  def self.put_user_in_random_city(latest_game, user_id)
    available_cities = latest_game.cities.select {|city| p city.player.barbarian}
    p latest_game.cities
    p available_cities
    available_cities.sample.player_id = user_id
  end

  private

  def self.not_playing?(latest, user_id)
    latest.cities.all? {|city| city.player.id != user_id}
  end

end
