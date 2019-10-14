Rails.application.routes.draw do
  resources :unprocessed_images, only: :create
  resource :my_page, only: :show

  match "/auth/:provider/callback", to: "sessions#create", via: %i[get post]
  delete "/auth", to: "sessions#destroy"

  root to: "tops#index"
end
