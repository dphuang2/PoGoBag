Rails.application.routes.draw do
  # Logging routes
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'

  # Global content
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/stats', to: 'stats#show'

  # User content
  get '/:id', to: 'users#show'
  get 'users/show'
  resources :users

  root 'static_pages#home'
end
