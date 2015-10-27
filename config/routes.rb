Rails.application.routes.draw do
  mount Upmin::Engine => '/admin'
  root to: 'pages#index'
  devise_for :users
  resources :users

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :registrations, only: [:create]
    end
  end
end
