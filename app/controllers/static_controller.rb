class StaticController < ApplicationController
  before_filter :authenticate_user!

  def app
    render file: '/public/skirmish-web/app', layout: false
  end
end
