class IndexController < ApplicationController
  before_action :authenticate_user!

  def current_player_id
    render json: {player_id: current_user.current_player.id}
  end

  def chat
    Pusher.trigger('skirmish_channel','chat_message', { message: params[:chat_message]})
    head :ok, :content_type => 'text/html'
  end
end
