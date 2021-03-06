require 'skirmish/game_setup'

class Skirmish::Game < ActiveRecord::Base
  has_many :players, class_name: 'Skirmish::Player', dependent: :destroy
  has_many :turns, class_name: 'Skirmish::Turn'

  attr_accessor :winner

  def self.join_new_game(user)
    player = user.create_player
    player.save

    ClientNotifier.notification('', "#{player.name} has joined the game")

    process_game(player)
  end

  def self.process_game(player)
    game = allocate_game
    game.add_player player
    game.award_random_barbarian_city player
    game.save
    game
  end

  def self.make
    Skirmish::GameSetup.setup_new_game_state
  end

  def add_player(player)
    self.players << player
    self.save
  end

  def self.needs_new_game?
    all.empty? || last.full?
  end

  def self.allocate_game
    if needs_new_game?
      Skirmish::Game.make
    else
      Skirmish::Game.last
    end
  end

  def player_count
    players.select{|p| not p.barbarian}.count
  end

  def award_random_barbarian_city(player)
    city_to_award = random_barbarian_city

    city_to_award.player = player
    player.cities << city_to_award

    4.times {city_to_award.units << Skirmish::Factories::Unit.make}
    city_to_award.save
    player.save
    save
  end

  def full?
    self.cities.all? {|city| !city.player.barbarian}
  end

  def self.is_user_in_latest_game?(current_user)
    if all.empty?
      false
    else
      Skirmish::Game.last.players.any? {|player| player.user_id == current_user.id}
    end
  end

  def cities
    self.players.map(&:cities).flatten
  end

  def self.process_turn(turn)
    game_state = Skirmish::GameState.from_game(turn.game.id)
    game_state.advance_turn

    turn.update_attributes(completed: true)
    ClientNotifier.notification('notice', 'Turn has advanced')
    ClientNotifier.push_state_notice
  end

  def process_turn_if_required
    turn = turns.last

    if turn.moves.count + turn.skips.count >= players.count
      Skirmish::Game.process_turn turn
    end
  end

  private

  def self.player_in_a_game?(user)
    all.map(&:players).flatten.include?(user.player)
  end

  def random_barbarian_city
    barbarian_cities.sample
  end

  def barbarian_cities
    cities.select { |city| city.player.barbarian }
  end


end
