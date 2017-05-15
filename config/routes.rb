Rails.application.routes.draw do
  post '/rate' => 'rater#create', :as => 'rate'
  root to: "pages#home"
  get "/about" => "pages#about"
  get "/news" => "pages#news"
  get "/login" => "sessions#new"
  post "/login" => "sessions#create"
  delete "/logout" => "sessions#destroy"
  resources :users do
    member do
      put "set_admin"
    end
  end
  resources :products
  resources :carts
  resources :line_items
  resources :orders
  resources :categories
end
