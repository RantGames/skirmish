class MoveController < ApplicationController
  before_action :authenticate_user!

  def create
    move = params[:move]
    game_id = params[:game_id]
    player = Player.find_by_user_id(current_user.id)
    game_state = GameState.from_match game_id
    move = Move.new(game_id: game_id,
                    player_id: player.id,
                    action: move['action'],
                    origin_id: move['origin_id'],
                    target_id: move['target_id'])

    if move.validate(game_state) && move.save
      render json: {message: 'Move created'}
    else
      render json: {message: 'There was a problem creating your move'}
    end
  end
end