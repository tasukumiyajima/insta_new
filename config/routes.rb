Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'users#facebook_login', as: :auth_callback
  get '/auth/failure', to: 'users#auth_failure', as: :auth_failure
  root 'static_pages#home'
  get '/home', to: 'static_pages#home'
  get '/search', to: 'static_pages#search'
  get '/signup', to: 'users#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users do
    member do
      get :following, :followers
    end

  end

  resources :microposts, only: [:new, :show, :create, :destroy] do
    resources :comments, only: [:create, :destroy]
  end
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :password_changes, only: [:edit, :update]
  resources :relationships, only: [:create, :destroy]
  resources :bookmarks, only: [:show, :create, :destroy]
  resources :notifications, only: [:index, :destroy]

end
