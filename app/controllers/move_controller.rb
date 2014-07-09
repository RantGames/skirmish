class MoveController < ApplicationController
  before_action :authenticate_user!

  def create
    args = {
      move_json: params[:move],
      game_id: params[:game_id],
      user: current_user,
    }
    move = Skirmish::Move::Factory.build(args)

    if move.save
      render json: { message: 'Move created'}
    else
      ClientNotifier.notification('error', move.error_message, current_user.current_player.id)
      render json: { message: move.error_message }, status: 422
    end
  end
end
