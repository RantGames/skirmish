class IndexController < ApplicationController
  before_action :authenticate_user!

  def current_player_id
    render json: {player_id: current_user.current_player.id}
  end
end
