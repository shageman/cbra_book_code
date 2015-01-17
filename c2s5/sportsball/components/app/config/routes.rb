App::Engine.routes.draw do
  get 'welcome/index'

  resources :games

  resources :teams

  root to: "welcome#index"
end
