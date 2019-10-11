Rails.application.routes.draw do
  resources :users
  resources :media, only: [:index, :show] do
    resource :ratings, only: [:create, :update, :destroy]
  end
  resources :genres
  resources :directors
  resources :actors

  root 'home#index'
  get  '/register', to: 'users#new'
  post '/register', to: 'users#create'
  get '/login', to: 'session#new'
  post '/login', to: 'session#create'
  delete '/logout', to: 'session#destroy'
  get '/medialist', to: 'media_list#index'
  get '/discover', to: 'discover#index'
  post '/discover/search', to: 'discover#search'
end