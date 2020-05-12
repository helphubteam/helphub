Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      post '/login', to: 'authentication#login'
      get '/profile', to: 'profiles#show'
      resources :help_requests, only: :index
    end
  end

  namespace :admin do
    resources :help_requests, only: %i[
      index new
      update edit
      destroy create
    ]
  end

  root to: redirect('/users/sign_in')
end
