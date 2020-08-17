Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  root 'static_pages#home'
  get  '/home', to: 'static_pages#home'
  get '/signup', to: 'users#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :microposts, only: [:new, :create, :destroy] do
    resources :comments, only: [:create, :destroy]
  end

  resources :relationships, only: [:create, :destroy]

end
