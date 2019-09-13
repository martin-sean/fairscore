Rails.application.routes.draw do
  resources :media
  resources :ratings
  resources :directors
  resources :actors
  resources :genres
  resources :statuses
  resources :users

  root 'home#index'
  get  '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
