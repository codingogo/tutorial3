Rails.application.routes.draw do

  devise_for :users
  resources :listings do 
    resources :orders, only: [:new, :create]
  end

  get 'pages/about'
  get 'pages/contact'
  get 'seller' => 'listings#seller'
  get 'sales' => 'orders#sales'
  get 'purchases' => 'orders#your_orders'

  root 'listings#index'

  post 'notify' => 'orders#notify'
  post 'purchases' => 'orders#your_orders'
end
