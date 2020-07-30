Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'welcome#show'

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :items, except: [:new, :create] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]

  resources :orders, only: [:new, :create, :show]

  get '/register', to: 'users#new'

  post "/cart/:item_id", to: "cart#add_item"
  post "/cart/:item_id/decrement", to: "cart#decrement_item"
  get "/cart", to: "cart#show"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  post '/sessions', to: 'sessions#create'

  namespace :merchant do
    get '/', to: 'dashboard#show', as: :dashboard
  end

  namespace :admin do
    get '/', to: 'dashboard#show'
  end

  resources :users, only: [:create]
  get '/profile', to: 'user/users#show'
  get '/profile/orders', to: 'user/orders#index'
  get '/profile/orders/:id', to: 'user/orders#show', as: :profile_order

  namespace :user do
    get '/edit', to: 'users#edit'
    patch '/', to: 'users#update'
    get '/password/edit', to: 'password#edit'
    patch '/password', to: 'password#update'
  end
end
