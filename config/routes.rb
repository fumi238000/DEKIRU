Rails.application.routes.draw do
  devise_for :users
  root "homes#index"
  resources :contents, only: %i[index new edit create update destroy]
  get "/content_show/:id", to: "contents#show", as: "content_show"
  resources :makes, only: %i[new create edit update destroy]
  resources :materials, only: %i[new create edit update destroy]
end
