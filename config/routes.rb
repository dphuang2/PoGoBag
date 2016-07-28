Rails.application.routes.draw do
  get 'users/show'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/contact', to: 'static_pages#contact'
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'

  resources :users

  root 'static_pages#home'
end
