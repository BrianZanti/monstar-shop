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
  scope module: :user do
    get '/profile', to: 'users#show'
    get '/user/edit', to: 'users#edit'
    patch '/user', to: 'users#update'
  end
end
