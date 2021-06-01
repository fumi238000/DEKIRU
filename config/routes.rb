Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
  }

  # devise_scope :user do
  #   get "sign_in", :to => "users/sessions#new"
  #   get "sign_out", :to => "users/sessions#destroy"
  # end

  get "/mypage/:id", to: "users#show", as: "mypage"
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
end
