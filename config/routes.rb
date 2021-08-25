Rails.application.routes.draw do
  resources :bookings do
    member do
      post :complete
    end
  end
  resources :cities
  resources :vehicles
  root :to => 'landing#index'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
