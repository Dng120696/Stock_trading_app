Rails.application.routes.draw do
  root 'pages#home'
  get 'news', to: 'pages#news'
  get 'pages/news_load', to: 'pages#news_load'

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
    resources :transactions, only: [:index, :new, :create] do
      get 'index_load', on: :collection
    end

    resources :dashboard, only: [:index] do
      get 'index_load', on: :collection

      collection do
        get 'search', to: 'dashboard#search_symbol', as: 'search_symbol'
      end
    end
    resource :profiles, only: [:edit] do
      patch 'add_balance', on: :member
      get 'confirm_otp'
      post 'process_otp_confirmation'
      get 'deposit_balance', on: :collection
      get 'otp_index', on: :collection
      post 'resend_otp', on: :member
    end


    resources :stocks, only: [:create]

    resources :portfolio, only: [:index] do
      get 'index_load_total', on: :collection
      get 'index_load_table', on: :collection
    end
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
