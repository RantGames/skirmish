Rails.application.routes.draw do

  get 'game_state/show'
  get 'game_state/new'
  get '/current_player_id', to: 'index#current_player_id'
  post 'move/create'

  devise_for :users, :controllers => {sessions: 'sessions'}
  root to: "static#app"

end
