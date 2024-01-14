#Pages controller inherits from the application controller. 
class PagesController < ApplicationController
  #Index displays multiple resources. 
  def index
  end
  
  #I need to remember what this does.
  def upload
    @user = User.new
    @user.avatar.attach(params[:avatar])
    @user.save
  end
end
