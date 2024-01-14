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


  post '/download_selected_pdfs', to: 'pdfs#download_selected_pdfs'

  get 'download_zip', to: 'pdfs#download_zip'

  post 'favorites/update', to: 'favorites#update'


end
