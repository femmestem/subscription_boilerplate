Rails.application.routes.draw do
  devise_for :users
  resources :products
  resources :sales
  get '/checkout/:permalink', to: 'transactions#new', as: :show_checkout
  post '/checkout/:permalink', to: 'transactions#create', as: :checkout
  get '/pickup/:guid', to: 'transactions#pickup', as: :pickup
end
