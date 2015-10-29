Rails.application.routes.draw do

  # mount Upmin::Engine => '/admin'
  root to: 'pages#index'
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)


  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      namespace :auth do
        resources :registrations, only: [:create] do
          collection do
            post :confirm
          end
        end
        resources :sessions, only: [:create] do
          collection do
            post :forgot
          end
        end
      end
      resources :lounges
    end
  end
end
