class FavoritesController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :authenticate_user! # Ensure user is authenticated
  
    def update
        ActiveRecord::Base.transaction do
          # Find or initialize the favorite record
          favorite = Favorite.find_or_initialize_by(user_id: current_user.id, rvp_id: params[:rvp_id])
          if params[:favorite] == 'true' || params[:favorite] == true
            if favorite.valid?  # Check if the record is valid
              favorite.save
              render json: { status: 'success', message: 'Favorite saved', favorite_id: favorite.id }
            else
              # Log the errors
              Rails.logger.error "Failed to save favorite: #{favorite.errors.full_messages}"
              render json: { status: 'error', message: favorite.errors.full_messages.to_sentence }, status: :unprocessable_entity
            end
          else
            if favorite.destroy
              render json: { status: 'success', message: 'Favorite removed', favorite_id: favorite.id }
            else
              render json: { status: 'error', message: 'Unable to remove favorite' }, status: :unprocessable_entity
            end
          end
        end
      end
    private
  
    def authenticate_user!
      # Add your authentication logic here
      # For example, you can use Devise for authentication
      # Replace this with your own authentication logic
      unless current_user
        render json: { status: 'error', message: 'Unauthorized' }, status: :unauthorized
      end
    end
  
    # Other controller actions and private methods...
  end