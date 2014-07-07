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
    player = Skirmish::Player.where(user_id: user.id, game_id: @game_id).first
    game_state = Skirmish::GameState.from_game(@game_id)
    move = Skirmish::Move.new(
                    player_id: player.id,
                    action: @move_json['action'],
                    target_id: @move_json['target_id'])
    @move_json['origin_ids'].each do |id|
      move.move_origins.new(origin_id: id)
    end

    self.error_messages = move.validate(game_state)

    if error_messages.empty? && move.save
      Skirmish::Turn.add_move(move, game_state.game)
      true
    else
      false
    end
  end

  def error_message
    if error_messages.empty?
      "There was a problem creating your move"
    else
      "Error occurred processing move: #{error_messages}"
    end
  end

private

  attr_accessor :error_messages
  attr_reader :move_json, :game_id, :user

end
