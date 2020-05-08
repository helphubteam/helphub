Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      # TODO: API routes
      post '/login', to: 'authentication#login'
    end
  end

  namespace :admin do
    # TODO: admin UI routes
  end

  root :to => redirect("/users/sign_in")
end
