Rails.application.routes.draw do

  root 'pages#home'
devise_for :users, controllers: {
  sessions: 'users/sessions'
}
devise_for :admin_users, controllers: {
  sessions: 'admin_users/sessions'
}

  namespace :admin do
    resources :trader
    resources :transactions, only: [:index]
    resources :dashboard do
      post 'approve', on: :member
    end
  end

  namespace :trader do
   resources :transactions, only: [:index,:new, :create ]
    resources :dashboard,only:[:index]
    resources :stocks,only: [:create]
    resources :portfolio,only: [:index]
  end

  mount ActionCable.server, at: '/cable'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
