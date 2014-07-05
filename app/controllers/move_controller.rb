class MoveController < ApplicationController
  before_action :authenticate_user!

  def create
    move = params[:move]
    game_id = params[:game_id]
    player = current_user
  end
end