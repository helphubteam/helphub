Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      post '/login', to: 'authentication#login'
      resources :help_requests, only: :index
    end
  end

  namespace :admin do
    # TODO: admin UI routes
  end

  root :to => redirect("/users/sign_in")
end
