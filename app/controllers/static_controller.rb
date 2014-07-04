class StaticController < ApplicationController
  def app
    render file: '/public/skirmish-web/app', layout: false
  end
end
