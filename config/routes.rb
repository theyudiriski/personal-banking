require 'sidekiq/web'

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  namespace :api do
    resources :users, only: [:create] do
      collection do
        post :login
        delete :logout
      end
    end

    resources :transactions, only: [:index] do
      collection do
        post :transfer
      end
    end

    resource :wallet, only: [:show]

    resources :stocks, only: [:index]
    get 'stocks/:symbol', to: 'stocks#show', as: :stock, constraints: { symbol: /.+/ }
  end

  mount Sidekiq::Web => '/sidekiq'
end
