Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
  }
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  get "/mypage/:id", to: "users#show", as: "mypage"
  get "/favorite_contents", to: "users#favorite"
  root "homes#index"
  resources :categories, only: %i[index new show edit create update destroy]
  resources :contents, only: %i[index new edit create update destroy]
  get "/content_show/:id", to: "contents#show", as: "content_show"
  get "/search_contents", to: "contents#search"
  get "/recommend_contents", to: "contents#recommend"
  get "/popular_contents", to: "contents#popular"
  get "/newest_contents", to: "contents#newest"
  resources :contents do
    resource :favorites, only: [:create, :destroy]
  end
  resources :makes, only: %i[new create edit update destroy]
  resources :materials, only: %i[new create edit update destroy]
  resources :reviews, only: %i[new create destroy]
  resources :questions, only: %i[index create destroy]
  resources :responses, only: %i[new create update edit destroy]
  resources :contacts, only: %i[index create]
  resources :tag_masters, only: %i[new create update edit destroy]
end
