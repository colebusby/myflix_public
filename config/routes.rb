Myflix::Application.routes.draw do
  root to: 'sessions#index'

  resources :sessions, only: [:index]
  get '/signin', to: 'sessions#new'
  post '/signin', to: 'sessions#create'
  get '/signout', to: 'sessions#destroy'

  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end
  get '/home', to: 'videos#index'

  resources :categories, only: [:show]

  resources :users, only: [:create, :show]
  get '/register', to: 'users#new'

  resources :relationships, only: [:destroy, :create]
  get 'people', to: 'relationships#index'

  resources :queue_items, only: [:create, :destroy]
  get '/my_queue', to: 'queue_items#index'
  post '/update_queue', to: 'queue_items#update_queue'

  get 'ui(/:action)', controller: 'ui'
end
