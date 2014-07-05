require 'skirmish/game_setup'

class GameStateController < ApplicationController
  def show
    render json: Skirmish::Game.find(params[:id])
  end

  def new
    if user_signed_in?
      render json: Skirmish::Game.join_new_game(current_user)
    else
      # return error to front end
    end
  end
end
