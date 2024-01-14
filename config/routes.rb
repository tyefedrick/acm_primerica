Rails.application.routes.draw do
  # Devise routes for user authentication
  devise_for :users
  
  # Root page
  root "pages#index"

  # Dashboard routes
  get '/dashboard', to: 'dashboards#show'
  
  # Dashboard resource with change_password action
  resource :dashboard, only: [:show] do
    patch 'change_password', on: :member
  end

  # PDF routes
  post '/save-pdf', to: 'pdfs#save'
  get 'rvps/files', to: 'rvps#all_files', as: :all_rvp_files
  post '/download_selected_pdfs', to: 'pdfs#download_selected_pdfs', as: :download_selected_pdfs
  get '/download_zip', to: 'pdfs#download_zip', as: :download_zip
  get '/file_not_found', to: 'pdfs#file_not_found', as: :file_not_found
  get '/pdfs/download/:id', to: 'pdfs#download', as: 'download_pdf'

  # Favorites routes
  post 'favorites/update', to: 'favorites#update'

  # Some other custom route
  get '/some_other_path', to: 'some_controller#some_action', as: :some_other_path

  # Rvps routes
  get '/rvps', to: 'rvps#index', as: :rvps
  resources :rvps
end