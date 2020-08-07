require 'sidekiq/web'

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { sessions: 'sessions' }

  namespace :api do
    namespace :v1 do
      post '/login', to: 'authentication#login'
      post '/refresh_token', to: 'authentication#refresh_token'
      get '/profile', to: 'profiles#show'
      post '/subscribe', to: 'profiles#subscribe'
      delete '/unsubscribe', to: 'profiles#unsubscribe'
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
      create
    ] do
      member do
        get :custom_fields
      end
    end

    resources :users, only: %i[
      index new
      update edit
      destroy create
    ]

    resources :organizations, only: %i[
      index new
      update edit
      create
    ] do
      member do
        post 'archive'
      end
    end

    resources :help_request_kinds, only: %i[
      index new
      update edit
      destroy create
    ]

    resources :reports, only: %i[index create]
  end

  root to: redirect('/users/sign_in')
end
