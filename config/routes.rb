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
    match "/available" => "products#available", as: :available, via: [:get], on: :collection
    match "/low_stock" => "products#low_stock", as: :low_stock, via: [:get], on: :collection
    match "/out_of_stock" => "products#out_of_stock", as: :out_of_stock, via: [:get], on: :collection
    match "/credits_history" => "products#credits_history", as: :credits_history, via: [:get], on: :member
    match "/sales_history" => "products#sales_history", as: :sales_history, via: [:get], on: :member
    match "/stocks_history" => "products#stocks_history", as: :stocks_history, via: [:get], on: :member
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
  resources :members
  resources :reports, only: [:index]
  resources :settings, only: [:index]
  resources :credits, only: [:index]

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

  namespace :accounting do
    resources :dashboard, only: [:index]
    resources :reports, only:[:index]
    resources :accounts
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
