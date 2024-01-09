class DashboardsController < ApplicationController
    before_action :authenticate_user!
  
    def show
    end
  
    def change_password
      @user = current_user
  
      if @user.update_with_password(user_params)
        bypass_sign_in(@user) # Sign the user in again to reflect the password change
        redirect_to dashboard_path, notice: "Password successfully updated."
      else
        flash.now[:alert] = "Error updating password. Please check your current password and try again."
        render :show
      end
    end
  
    private
  
    def user_params
      params.require(:user).permit(:current_password, :password, :password_confirmation)
    end
  end