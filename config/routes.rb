Rails.application.routes.draw do

  resources :losers
  resources :winners
  resources :statistics
  resources :rounds
  resources :tournaments
  resources :teams
  root to: 'dashboard#index'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  delete 'logout' => 'sessions#destroy'

  resources :users do
    member do
      post :toggle_status
    end
  end
  resources :maps do
    member do
      post :toggle_status
    end
  end
  resources :sessions
  
end
