class GameStateController < ApplicationController
  def show
    render json: Skirmish::Game.find(params[:id])
  end

  def new
    render json: Skirmish::Game.allocate_game
  end
end
