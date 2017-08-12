Rails.application.routes.draw do

  resources :tournaments do
    resources :rounds
  end

  resources :teams
  root to: 'dashboard#index'

  get 'randomizer' => 'randomizer#index'
  get 'randomizer_raffle' => 'randomizer#raffle'
  get 'randomizer_reset' => 'randomizer#reset'
  get 'randomizer_start' => 'randomizer#start'
  get 'randomizer_finish' => 'randomizer#finish'
  get 'randomizer_open_map' => 'randomizer#open_map'

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
