Rails.application.routes.draw do
  get "archives/index"
  resources :entries
  resource  :profile, only: [:show, :edit, :update]
  resources :activities, only: [:index, :new, :create, :destroy]
  get "food_search", to: "food_search#index"
  root to: "entries#index"

  get "up" => "rails/health#show", as: :rails_health_check
end
