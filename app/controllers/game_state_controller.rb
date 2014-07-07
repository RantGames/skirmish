require 'skirmish/game_setup'

class GameStateController < ApplicationController

  before_filter :authenticate_user!

  def show
    if current_user.is_in_a_game?
      render json: current_user.current_game
    else
      render nothing: true, status: 403
    end

  end

  def new
    if Skirmish::Game.is_user_in_latest_game?(current_user)
      render nothing: true, status: 403
    else
      render json: Skirmish::Game.join_new_game(current_user)
    end
  end

end
