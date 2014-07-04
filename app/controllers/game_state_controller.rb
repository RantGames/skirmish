class GameStateController < ApplicationController
  def show
    render json: Game::Match.find(params[:id])
  end

  def new
    render json: Game::Match.allocate_match
  end
end
