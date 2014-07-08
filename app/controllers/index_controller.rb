class IndexController < ApplicationController
  before_action :authenticate_user!

  def current_player_id
    render json: {player_id: current_user.current_player.id}
  end

  def chat
    message = params[:chat_message]
    message = "#{current_user.current_player.name}: #{message}"
    ClientNotifier.notification('chat', message)
    head :ok
  end
end
