Rails.application.routes.draw do

  resources :tournaments do
    resources :rounds do
      collection do
        get :move_to_winner
        get :move_to_loser
      end
    end
  end

  resources :teams
  root to: 'dashboard#index'

  get 'compare' => 'compare#index'
  get 'compare_players' => 'compare#compare_players'
  get 'get_maps_from_tournament' => 'compare#get_maps_from_tournament'
  get 'get_tournaments_from_season' => 'compare#get_tournaments_from_season'
  get 'randomizer' => 'randomizer#index'
  get 'randomizer_raffle' => 'randomizer#raffle'
  get 'randomizer_reset' => 'randomizer#reset'
  get 'randomizer_start' => 'randomizer#start'
  get 'randomizer_finish' => 'randomizer#finish'
  get 'randomizer_open_map' => 'randomizer#open_map'
  get 'randomizer_select' => 'randomizer#select'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  get 'logout' => 'sessions#destroy'
  delete 'logout' => 'sessions#destroy'

  resources :server_configurations do
    member do
      post :toggle_status
    end
  end
  resources :games do
    member do
      post :toggle_status
    end
  end
  resources :seasons
  resources :users
  resources :maps do
    member do
      post :toggle_status
    end
  end
  resources :sessions

end
