Rails.application.routes.draw do
  resources :tests, only: %i[index]
  resources :unprocessed_images, only: %i[create show edit update]
  resource :my_page, only: :show

  match "/auth/:provider/callback", to: "sessions#create", via: %i[get post]
  delete "/auth", to: "sessions#destroy"

  root to: "tops#index"
end
