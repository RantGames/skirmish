Rails.application.routes.draw do

  get 'game_state/process_turn'
  get 'game_state/show'
  get 'game_state/new'
  get '/current_player_id', to: 'index#current_player_id'
  post 'move/create'
  post '/chat', to: 'index#chat'

  devise_for :users
  root to: "static#app"

end
