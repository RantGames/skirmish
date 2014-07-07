class IndexController < ApplicationController
  before_action :authenticate_user!

  def current_user
    render json: {user_id: current_user.id}
  end
end
