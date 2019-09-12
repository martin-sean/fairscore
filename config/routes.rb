Rails.application.routes.draw do
  resources :media
  resources :ratings
  root 'home#index'

  resources :directors
  resources :actors
  resources :genres
  resources :statuses
  resources :users
end
