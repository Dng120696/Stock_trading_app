Rails.application.routes.draw do

  root 'pages#home'
  devise_for :users
  devise_for :admin_users


  namespace :admin do
    resources :trader, only: [:new, :create, :index, :show, :edit, :update]
    resources :transactions, only: [:index]
    resources :dashboard do
      post 'approve', on: :member
    end
  end

  namespace :trader do
    resources :transactions, only: [:index, :new, :create]
    resources :dashboard, only: [:index]
    resources :stocks, only: [:create]
  end  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
