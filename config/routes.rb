Rails.application.routes.draw do
  resources :listings
  resources :missions, only: [:index]
end
