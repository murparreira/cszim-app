Rails.application.routes.draw do

  resources :tournaments do
    resources :rounds do
      collection do
        get :move_to_winner
        get :move_to_loser
      end
    end
  end

  mount GoodJob::Engine => 'good_job'

  resources :teams
  root to: 'dashboard#index'

  get 'v1/dashboard' => 'v1/dashboard#index'
  get 'v2/dashboard' => 'v2/dashboard#index'

  get 'compare' => 'compare#index'
  get 'compare_players' => 'compare#compare_players'
  get 'get_maps_from_tournament' => 'compare#get_maps_from_tournament'
  get 'get_tournaments_from_season' => 'compare#get_tournaments_from_season'

  get 'manager' => 'manager#index'
  get 'manager_raffle' => 'manager#raffle'
  get 'manager_reset' => 'manager#reset'
  get 'manager_start' => 'manager#start'
  get 'manager_finish' => 'manager#finish'
  get 'manager_open_map' => 'manager#open_map'
  get 'manager_select' => 'manager#select'

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
  resources :users do
    member do
      get :get_data
    end
  end

  resources :maps do
    member do
      post :toggle_status
    end
  end
  resources :sessions

end
