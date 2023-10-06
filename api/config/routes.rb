# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :completed_orders, only: [:create]
      get 'loyalty_stats/:customer_id', to: 'loyalty_stats#show'
    end
  end
end
