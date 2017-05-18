Rails.application.routes.draw do

  resources :tournaments do
    resources :rounds
  end

  resources :teams
  root to: 'dashboard#index'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  delete 'logout' => 'sessions#destroy'

  resources :users
  resources :maps do
    member do
      post :toggle_status
    end
  end
  resources :sessions

end
