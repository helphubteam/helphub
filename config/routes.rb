Rails.application.routes.draw do
  namespace :api do
    resources :articles, only: :index
  end
end
