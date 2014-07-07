require 'psych'
require 'deep_merge/rails_compat'

class GameStateLoader
  def self.parse(file)
    parsed_contents = Psych.load(File.read(file))
    initial_game = Skirmish::Game.create
    initial_game.players << parse_players(parsed_contents['initial_state']['players'])
    initial_game.save
    initial_game_state = Skirmish::GameState.new(initial_game)

    parsed_contents['moves'].each{|m| parse_move(m, initial_game_state)}

    expected_state = parsed_contents['expected_state'].deeper_merge(parsed_contents['initial_state'], {merge_hash_arrays: true})
    expected_game = Skirmish::Game.create
    expected_game.players << parse_players(expected_state['players'])
    expected_game_state = Skirmish::GameState.new(expected_game)
    [initial_game_state, expected_game_state]
  end


  private
  def self.parse_players(players)
    player_models = []
    players.each do |player|
      player_model = Skirmish::Player.new(name: player['name'])
      player_model.cities << parse_cities(player)
      player_models << player_model
    end

    player_models
  end

  def self.parse_cities(player)
    city_models = []
    player['cities'].each do |city|
      city_model = Skirmish::City.new(name: city['name'])
      city['units'].times do
        unit = Skirmish::Unit.new(unit_type: 'infantry', attack: 1, defense: 1)
        city_model.units << unit
      end
      city_models << city_model
    end

    city_models.select{|c| not c.name == 'remove'}
  end

  def self.parse_move(move, game_state)
    player = game_state.players[move['player']-1]
    players_cities = game_state.cities_for_player(player.id)
    units_for_move = players_cities.find{|c| c.name == move['from']}.units.take(move['quantity'])
    city_target = find_target(move['action'], move, game_state)

    action_lookups = {
        :move => Skirmish::Move::MOVE_UNIT,
        :attack => Skirmish::Move::ATTACK_UNIT
    }

    move_model = Skirmish::Turn.current_turn_for_game(game_state.game).moves.create(player_id: player.id,
                                                                    action: action_lookups[move['action']],
                                                                    target_id: city_target.id)
    units_for_move.each do |unit|
      move_model.move_origins.create(origin_id: unit.id)
    end

    move_model
  end

  def self.find_target(action, move, game_state)
    case action
      when :move
        game_state.cities_for_player(game_state.players[move['player']-1].id).find{|c| c.name == move['to']}
      when :attack
        game_state.cities_for_player(game_state.players[move['target']-1].id).find{|c| c.name == move['to']}
    end
  end
end