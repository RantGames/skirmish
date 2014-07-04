class StaticController < ApplicationController
  def app
    render file: '/public/skirmish-web/app'
  end
end
