Rails.application.routes.draw do
  
  root to: "events#index"
  get "events/search", to: "events#search", as: "events_search"
  
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks",
    confirmations: "users/confirmations",
    passwords: "users/passwords"
  }

  resources :events do
    collection do
      get :search
    end
  end

  resources :users, only: [:show, :edit, :update] do
    get :favourite
  end


  resources :favourites, only: [:create, :destroy]

  #resources :events, only: [:index, :show]

  resources :carts, only: [:show]

  get 'checkouts/index/:id' => 'checkouts#index', as: 'checkouts_index'
  get 'checkouts/show'
  get 'checkouts/new'

  post 'checkouts/create' => "checkouts#create", as: "checkouts_create"
  get 'checkouts/success' => "checkouts#success", as: "checkouts_success"
  get 'checkouts/cancel' => "checkouts#cancel", as: "checkouts_cancel"

  get 'carts/show'
  
  get 'carts/:cart_id' => "carts#show", as: "cart"
  get 'cart_items/:cart_item_id' => "cart_items#show", as: "cart_item"
  
  post 'cart_items/:cart_item_id/increase' => "cart_items#increment_number", as: "cart_item_increase"
  post 'cart_items/:cart_item_id/decrease' => "cart_items#decrease_number", as: "cart_item_decrease"
  post 'cart_items' => "cart_items#create"

  delete 'carts/:cart_id' => "carts#destroy"
  delete 'cart_items/:cart_item_id' => "cart_items#destroy", as: "cart_item_delete"

  get 'profile', to: 'users#show', as: "user_show"
  get 'profile', to: 'users#profile', as: "user_profile"


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  
end
