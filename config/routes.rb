Rails.application.routes.draw do
  devise_for :users
  root "pages#index"

  get '/dashboard', to: 'dashboards#show'
  
  resource :dashboard, only: [:show] do
    patch 'change_password', on: :member
  end

  post '/save-pdf', to: 'pdfs#save'
  get 'rvps/files', to: 'rvps#all_files', as: :all_rvp_files


  post '/download_selected_pdfs', to: 'pdfs#download_selected_pdfs', as: :download_selected_pdfs

  get '/download_zip', to: 'pdfs#download_zip', as: :download_zip

  post 'favorites/update', to: 'favorites#update'

  get '/some_other_path', to: 'some_controller#some_action', as: :some_other_path

  get '/file_not_found', to: 'pdfs#file_not_found', as: :file_not_found

  get '/pdfs/download/:id', to: 'pdfs#download', as: 'download_pdf'

  get '/rvps', to: 'rvps#index', as: :rvps

  resources :rvps

end
