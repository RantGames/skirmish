class GameStateController < ApplicationController
  def show
    @match = Game::Match.find(params[:id])
    render json: @match
  end
end
