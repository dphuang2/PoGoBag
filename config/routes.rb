Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')

  get 'users/show'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/logout', to: 'sessions#destroy'

  get '/contact', to: 'static_pages#contact'
  get '/home', to: 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/:id', to: 'users#show'

  resources :users

  root 'static_pages#home'
end
