Rails.application.routes.draw do

  resources :franchise_requests
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
            post :resend_code
          end
        end
        resources :sessions, only: [:create] do
          collection do
            post :forgot

          end
        end
      end
      resources :lounges, only: [:index, :show]
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
      resources :achievements, only: [:index] do
        member {
          post :viewed
        }
      end
      resources :users, only: [:update, :show] do
        collection {
          get :rating
        }
        member {
          get :load_client_data
          get :load_hookmaster_data
        }
      end
      resources :works, only: [:index]
      resources :meets do
        member do
          post :accept
          post :decline
        end
      end
    end
  end
end
