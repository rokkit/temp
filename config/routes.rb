Rails.application.routes.draw do
  # mount Upmin::Engine => '/admin'
  root to: 'pages#index'
  get 'pages/schedule', to: 'pages#schedule'
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
      resources :lounges, only: [:index]
      resources :reservations, only: [:index, :create, :destroy] do
        collection do
          get :load_data
        end
      end
      resources :tables, only: [:index]
      resources :skills, only: [:index] do
        member do
          post :take
          post :use
        end
      end
      resources :payments, only: [:create]
      resources :achievements, only: [:index]
      resources :users, only: [:update, :show]
    end
  end
end
