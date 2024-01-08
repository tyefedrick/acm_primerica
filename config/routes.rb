Rails.application.routes.draw do
  devise_for :users
  root "pages#index"

  get '/dashboard', to: 'dashboards#show'

end
