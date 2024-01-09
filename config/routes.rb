Rails.application.routes.draw do
  resources :rvps
  devise_for :users
  root "pages#index"

  get '/dashboard', to: 'dashboards#show'
  
  resource :dashboard, only: [:show] do
    patch 'change_password', on: :member
  end

end
