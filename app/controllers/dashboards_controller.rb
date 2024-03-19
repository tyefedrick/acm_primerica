#controls are responsible for handling HTTP requests and serving responses.
class DashboardsController < ApplicationController
  #This before action is making sure that no one can access these actions until the user is authenticated (logged in).
  before_action :authenticate_user!
  
  #this show action is what allows the user to see the dashboard.
  def show
  end
  
  #as the name suggests this is the actions that controls the changing of the password.
  def change_password

    # @user (person currently logged in), is the current_user, therefore they are able to edit the data.
    @user = current_user
  
    #As the user updates the password, they will be logged in again if the password is succesfully changed.
    if @user.update_with_password(user_params)
      bypass_sign_in(@user) # Sign the user in again to reflect the password change
      redirect_to dashboard_path, notice: "Password successfully updated."
    else
       # Only show alert for password change errors
    if params[:user][:password].present? && params[:user][:password_confirmation].present?
      flash.now[:alert] = "Error updating password. Please check your current password and try again."
    end
      #command to show the error to the user
      render :show
    end
  end
  
  #The user does not see these actions when they are private.
  private
    #Essentailly allows the user to complete the following commands if they are logged in as the user. 
    def user_params
      params.require(:user).permit(:current_password, :password, :password_confirmation)
    end
end