Rails.application.routes.draw do

  get 'game_state/show'
  get 'game_state/new'

  devise_for :users, :controllers => {sessions: 'sessions'}
  root to: "static#app"

end
