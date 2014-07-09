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

  def skip_turn
    if current_user.is_in_a_game? && !current_user.current_player.has_skipped?
      turn = Skirmish::Turn.current_turn_for_game current_user.current_game
      turn.skips.create(player_id: current_user.current_player.id)

      ClientNotifier.notification('notice', "#{current_user.current_player.name} has skipped their turn")

      head :ok
    else
      ClientNotifier.notification('notice', 'You already skipped your turn', current_user.current_player.id)
      render nothing: true, status: 403
    end
  end

end
