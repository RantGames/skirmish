require 'skirmish/game_setup'

class GameStateController < ApplicationController
  # TODO: fix hack (allowing unauthed users to process turns)
  before_filter :authenticate_user!, except: :process_turn

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

  def process_turn
    Skirmish::Game.process_turn(Skirmish::Turn.last)

    render json: { message: 'hopefully processed turn' }
  end

end
