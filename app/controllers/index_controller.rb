class IndexController < ApplicationController
  before_action :authenticate_user!

  def current_user_id
    render json: {user_id: current_user.id}
  end
end
