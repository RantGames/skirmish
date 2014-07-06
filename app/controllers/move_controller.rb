class MoveController < ApplicationController
  before_action :authenticate_user!

  def create
    move_json = JSON.parse(params[:move])
    game_id = params[:game_id]
    player = Skirmish::Player.where(user_id: current_user.id, game_id: game_id).first
    game_state = Skirmish::GameState.from_game game_id
    move = Skirmish::Move.new(
                    player_id: player.id,
                    action: move_json['action'],
                    target_id: move_json['target_id'])
    move_json['origin_ids'].each do |id|
      move.move_origins.new(origin_id: id)
    end

    error_message = move.validate(game_state)

    if error_message.empty? && move.save
      Skirmish::Turn.add_move(move, game_state.game)
      render json: {message: 'Move created'}
    elsif not error_message.empty?
      render json: {message: "Error occurred processing move: #{error_message}"}, status: 422
    else
      render json: {message: 'There was a problem creating your move'}
    end
  end
end