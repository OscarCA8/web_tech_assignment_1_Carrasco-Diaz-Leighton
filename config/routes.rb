Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  resources :challenges do
    resources :progress_entries, only: [:index, :new, :create]
    resources :challenge_badges, only: [:index]
    member do
      post :join
      delete :leave
    end
  end

  resources :progress_entries, only: [:show, :edit, :update, :destroy]
  resources :badges
  resources :participations
  resources :user_badges, only: [:index]
  resources :notifications, only: [:index, :show, :destroy]
  root "challenges#index"

  # get "/login", to: "sessions#new"
  # post "/login", to: "sessions#create"
  # delete "/logout", to: "sessions#destroy"
end
