Rails.application.routes.draw do
  resources :users
  resources :media do
    member do
      post '/rate', to: 'ratings#create'
      put '/rate', to: 'ratings#update'
      delete '/unrate', to: 'ratings#destroy'
    end
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
end
