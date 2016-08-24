Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users", sessions: "users/sessions" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "store/index"
  root :to => "store#index", :constraints => lambda { |request| request.env['warden'].user.nil? }, as: :unauthenticated_root
  root :to => 'store#index', :constraints => lambda { |request| request.env['warden'].user.role == 'proprietor' if request.env['warden'].user }, as: :admin_root
  root :to => 'products#index', :constraints => lambda { |request| request.env['warden'].user.role == 'stock_custodian' if request.env['warden'].user }, as: :stock_custodian_root
  root :to => 'accounting/accounts#index', :constraints => lambda { |request| request.env['warden'].user.role == 'bookkeeper' if request.env['warden'].user }, as: :bookkeeper_root

  resources :products do
    resources :stocks, only: [:new, :create], module: :products
  end
  resources :line_items do
    resources :credit_payments, only: [:new, :create], module: :accounting
  end
  resources :carts
  resources :orders do
      match "/guest" => "orders#guest",  via: [:post], on: :member
      match "/print" => "orders#print",  via: [:get], on: :member
      match "/print_invoice" => "orders#print_invoice",  via: [:get], on: :member
      match "/print_official_receipt" => "orders#print_official_receipt",  via: [:get], on: :member
      match "/scope_to_date" => "orders#scope_to_date",  via: [:get], on: :collection



    end
  resources :members do
    resources :full_payments, only: [:new, :create], module: :members
    resources :line_items, only: [:index], module: :members do
      match "/scope_to_date" => "line_items#scope_to_date",  via: [:get], on: :collection, module: :members
    end
  end
  resources :reports, only: [:index]
  resources :settings, only: [:index]
  resources :credits, only: [:index]
  resources :available_products, only: [:index]

  resources :low_stock_products, only: [:index]
  resources :out_of_stock_products, only: [:index]

  resources :refunds, only: [:index, :new, :create]
  resources :taxes, only: [:new, :create]
  resources :categories
  resources :wholesales
  resources :stocks, only: [:index, :show, :new, :create] do
    match "/scope_to_date" => "stocks#scope_to_date",  via: [:get], on: :collection
    resources :refunds, only: [:new, :create], module: :stocks

  end
  namespace :wholesales do
    resources :line_items
    resources :orders
  end
  resources :businesses
  resources :info, only: [:index]
  resources :users, only: [:show]
  resources :employees, only: [:new, :create]
  resources :accounting, only: [:index]
  namespace :accounting do
    resources :balance_sheet, only:[:index]
    resources :income_statement, only:[:index]
    resources :dashboard, only: [:index]
    resources :reports, only:[:index]
    resources :accounts do
      match "/activate" => "accounts#activate", via: [:post], on: :member
      match "/deactivate" => "accounts#deactivate", via: [:post], on: :member

    end
    resources :assets, controller: 'accounts', type: 'Accounting::Asset'
    resources :liabilities, controller: 'accounts', type: 'Accounting::Liability'
    resources :equities, controller: 'accounts', type: 'Accounting::Equity'
    resources :revenues, controller: 'accounts', type: 'Accounting::Revenue'
    resources :expenses, controller: 'accounts', type: 'Accounting::Expense'
    resources :entries do
      match "/scope_to_date" => "entries#scope_to_date", as: :scope_to_date, via: [:get], on: :collection
    end
  end

  namespace :owner do
    resources :dashboard, only: [:index]
  end
  resources :warranties, only: [:new, :create]
  resources :birs
end
