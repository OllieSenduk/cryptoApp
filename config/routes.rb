Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/y', as: 'rails_admin'
  devise_for :users
  root to: 'pages#home'
  resources :trade_processes, only: [:show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
