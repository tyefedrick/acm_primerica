#The base controller is responsible for providing fundamental functionality for the web requests. 
class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    
    def after_sign_in_path_for(resource)
        # Logic to load user favorites
        @favorites = current_user.favorites.includes(:rvp)
        # Then redirect to a specific path
        super
      end
end
