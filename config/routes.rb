Rails.application.routes.draw do
  devise_for :users
  root "pages#index"

  get '/dashboard', to: 'dashboards#show'
  
  resource :dashboard, only: [:show] do
    patch 'change_password', on: :member
  end

  post '/save-pdf', to: 'pdfs#save'

  get 'rvps/files', to: 'rvps#all_files', as: :all_rvp_files
  resources :rvps

end
