Rails.application.routes.draw do
  match "/auth/:provider/callback", to: "sessions#create", via: %i[get post]
  delete "/auth", to: "sessions#destroy"
end
