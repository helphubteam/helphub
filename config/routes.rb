require 'sidekiq/web'

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { 
    sessions: 'sessions', 
    passwords: 'passwords', 
    registrations: 'registrations',
    confirmations: 'confirmations'
  }

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
      resources :scores, only: :index
    end

    namespace :v2 do
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
      resources :scores, only: :index
    end
  end

  namespace :admin do
    get 'dashboard', to: 'dashboard#index'

    post 'recurring', to: 'manual_pushes#recurring'

    resources :help_requests, only: %i[
      index new
      update edit
      create
    ] do
      member do
        get :custom_fields
        post :clone
      end
    end

    resources :settings, only: %i[index] do
      collection do
        put :update
      end
    end

    resources :users, only: %i[
      index new
      update edit
      destroy create
    ] do
      member do
        post :approve
      end
    end

    resources :organizations, only: %i[
      index new
      update edit
      create
    ] do
      member do
        post 'archive'
        get 'config', to: 'organization_configs#show'
        patch 'config', to: 'organization_configs#update'
      end
    end

    resources :help_request_kinds, only: %i[
      index new
      update edit
      destroy create
    ]

    resources :reports, only: %i[index create]
  end

  get "pages/confirm_email", to: "pages#confirm_email"
  get "pages/waiting_for_moderator", to: "pages#waiting_for_moderator"
  
  root to: redirect('/users/sign_in')
end
