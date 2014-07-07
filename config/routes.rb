Rails.application.routes.draw do

  get 'game_state/show'
  get 'game_state/new'
  get '/current_user', to: 'index#current_user'
  post 'move/create'

  devise_for :users, :controllers => {sessions: 'sessions'}
  root to: "static#app"

end
