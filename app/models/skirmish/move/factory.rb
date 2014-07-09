class Skirmish::Move::Factory

  def self.build(args)
    new(args)
  end

  def initialize(args)
    @move_json = args.fetch(:move_json)
    @game_id = args.fetch(:game_id)
    @user = args.fetch(:user)
  end

  def save
    player = Skirmish::Player.where(user_id: user.id, game_id: game_id).first
    game_state = Skirmish::GameState.from_game(game_id)
    move = create_move(game_state, player)

    self.validation_error = move.validate(game_state)

    if validation_error.empty? && move.save
      Skirmish::Turn.add_move(move, game_state.game)
      true
    else
      false
    end
  end


  def error_message
    if validation_error.empty?
      'Error saving move'
    else
      "Error occurred processing move: #{validation_error}"
    end
  end

private

  def create_move(game_state, player)
    move = Skirmish::Move.new(
        player_id: player.id,
        action: move_json['action'],
        origin_id: move_json['origin_id'],
        target_id: move_json['target_id'])
    city_to_pull_units_from = game_state.get_city(move.origin_id)
    units = city_to_pull_units_from.units.take(move_json['quantity'])
    units.each do |unit|
      move.move_origins.new(origin_id: unit.id)
    end
    move
  end

  attr_accessor :validation_error
  attr_reader :move_json, :game_id, :user

end
