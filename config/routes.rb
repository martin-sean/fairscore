Rails.application.routes.draw do
  resources :ratings
  root 'home#index'

  resources :directors
  resources :actors
  resources :genres
  resources :statuses
  resources :media
  resources :users
end
