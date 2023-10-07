# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :completed_orders, only: [:create]
      get 'customers/:customer_id/completed_orders', to: 'completed_orders#index'
      get 'customers/:customer_id/loyalty_stats', to: 'loyalty_stats#show'
    end
  end
end
