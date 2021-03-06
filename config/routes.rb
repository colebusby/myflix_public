Myflix::Application.routes.draw do
  require 'sidekiq/web'

  root to: 'sessions#index'

  resources :categories, only: [:show]

  resources :invitations, only: [:new, :create]

  resources :password_recoveries, only: [:create]
  get 'password_recovery', to: 'password_recoveries#new'
  get 'password_recovery_confirmation', to: 'password_recoveries#confirm'

  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'

  resources :queue_items, only: [:create, :destroy]
  get 'my_queue', to: 'queue_items#index'
  post 'update_queue', to: 'queue_items#update_queue'

  resources :relationships, only: [:destroy, :create]
  get 'people', to: 'relationships#index'

  resources :sessions, only: [:index]
  get 'signin', to: 'sessions#new'
  post 'signin', to: 'sessions#create'
  get 'signout', to: 'sessions#destroy'

  resources :users, only: [:create, :show] do
    resources :payments, only: [:index]
    post 'update_card', to: 'payments#update_card'
    post 'cancel_subscription', to: 'payments#cancel_subscription'
  end
  get 'register', to: 'users#new'
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'

  resources :videos, only: [:show] do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end
  get 'home', to: 'videos#index'

  mount Sidekiq::Web, at: '/sidekiq'

  get 'ui(/:action)', controller: 'ui'

  mount StripeEvent::Engine => '/stripe_events'

  ##
  # Actors
  ##

  namespace :admin do
    resources :videos, only: [:new, :create]

    resources :payments, only: [:index]
  end
end
