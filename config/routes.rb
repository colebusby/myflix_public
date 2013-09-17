Myflix::Application.routes.draw do
  root to: 'sessions#index'

  get '/home', to: 'videos#index'
  get '/register', to: 'users#new'
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  get 'signout', to: 'sessions#destroy'
  get 'my_queue', to: 'queue_items#index'

  resources :sessions, only: [:index]

  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :ratings, only: [:create]
  end

  resources :categories, only: [:show]

  resources :users, only: [:create]

  resources :queue_items, only: [:create]

  get 'ui(/:action)', controller: 'ui'
end
