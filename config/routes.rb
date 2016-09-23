Rails.application.routes.draw do
  # Logging routes
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'

  # Global content
  get '/home', to: 'static_pages#home'
  get '/testing', to: 'static_pages#testing'
  get '/about', to: 'static_pages#about'
  get '/stats', to: 'stats#show'
  get '/stats/:stat', to: 'stats#show'

  # User content
  get '/search', to: 'users#index'
  get '/:id', to: 'users#show'
  get '/:id/:stat', to: 'users#get_pokemon'

  root 'static_pages#home'
end
