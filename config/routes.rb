Rails.application.routes.draw do
  resources :directors
  resources :actors
  resources :genres
  resources :statuses
  resources :media
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
