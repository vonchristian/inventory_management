Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users", sessions: "users/sessions" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'store#index', as: 'store'
  get "store/index"
  resources :products do
    resources :stocks
  end
  resources :line_items
  resources :carts
  resources :orders do
      match "/guest" => "orders#guest",  via: [:post], on: :member
    end
  resources :members
  resources :reports, only: [:index]
  resources :settings, only: [:index]
  resources :credits, only: [:index]
  resources :available_products, only: [:index]

  resources :low_stock_products, only: [:index]
  resources :out_of_stock_products, only: [:index]



  resources :categories
  resources :wholesales
  resources :stocks, only: [:index, :show]
  namespace :wholesales do
    resources :line_items
    resources :orders
  end
  resources :businesses
end
