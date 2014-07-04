class GameStateController < ApplicationController
  def show
    GameState.json_by_id(params(:id))
  end
end
