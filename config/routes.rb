Rails.application.routes.draw do

  get 'game_state/show'

  devise_for :users, :controllers => {sessions: 'sessions'}

  root to: "static#app"
end
