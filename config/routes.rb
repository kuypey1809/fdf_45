Rails.application.routes.draw do
  root "static_pages#home"

  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/get-product/:id", to: "products#load_by_category", as: "getListProduct"
  get "/myOrders", to: "orders#personal_show"

  resources :users
  resources :categories
  resources :products
  resources :carts, only: :index
  resources :orders
end
