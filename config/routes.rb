Rails.application.routes.draw do
  root 'products#index'
  devise_for :users
  resources :products
  resources :sales
  get '/checkout/:permalink', to: 'transactions#new', as: :show_checkout
  post '/checkout/:permalink', to: 'transactions#create', as: :checkout
  get '/pickup/:guid', to: 'transactions#pickup', as: :pickup
  get '/download/:guid', to: 'transactions#download', as: :download
end
