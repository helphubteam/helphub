require 'sidekiq/web'

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  authenticate :user, lambda {|u| u.admin?} do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { sessions: "sessions" }

  namespace :api do
    namespace :v1 do
      post '/login', to: 'authentication#login'
      get '/profile', to: 'profiles#show'
      resources :help_requests, only: :index do
        member do
          post :assign
          post :submit
          post :refuse
        end
      end
    end
  end

  namespace :admin do
    resources :help_requests, only: %i[
      index new
      update edit
      destroy create
    ]

    resources :users, only: %i[
      index new
      update edit
      destroy create
    ]

    resources :organizations, only: %i[
      index new
      update edit
      destroy create
    ]
  end

  root to: redirect('/users/sign_in')
end
