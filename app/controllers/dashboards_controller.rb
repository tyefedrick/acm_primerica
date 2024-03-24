#controls are responsible for handling HTTP requests and serving responses.
class DashboardsController < ApplicationController
  #This before action is making sure that no one can access these actions until the user is authenticated (logged in).
  before_action :authenticate_user!
  
  #this show action is what allows the user to see the dashboard.
  def show
  end
  
  #as the name suggests this is the actions that controls the changing of the password.
  def change_password
    @user = current_user

    if @user.update_with_password(user_params)
      bypass_sign_in(@user)
      # Redirect and set flash notice for success
      flash[:password_change_success] = "Your password has been successfully updated."
      redirect_to dashboard_path
    else
      # Set flash.now alert for errors, will only last for the current request
      flash.now[:password_change_error] = @user.errors.full_messages.join(', ')
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