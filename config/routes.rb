Rails.application.routes.draw do
  devise_for :users
  root to: 'cars#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :cars, only: %i[index show new create update destroy] do
    resources :bookings, only: %i[new create]
  end

  resources :bookings, only: %i[destroy update]

  get '/dashboard', to: "dashboards#index"
end
