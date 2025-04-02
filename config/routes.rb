Rails.application.routes.draw do
  devise_for :users

  root to: "conversations#index"

  resources :conversations, only: [ :index, :show, :new, :create ] do
    resources :messages, only: [ :create ]
  end

  namespace :api do
    namespace :v1 do
      resources :conversations do
        resources :messages
      end

      resources :accounts do
        resources :transactions
      end

      resources :categories
      resources :budgets
    end
  end
end
