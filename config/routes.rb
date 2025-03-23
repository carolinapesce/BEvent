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

  #resources :events, only: [:index, :show]

  resources :carts, only: [:show]

  get 'profile', to: 'users#show', as: "user_show"


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
