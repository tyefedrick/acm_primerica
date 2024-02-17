#Pages controller inherits from the application controller. 
class PagesController < ApplicationController
  #Index displays multiple resources. 
  def index
    @sorted_rvps = Rvp.all.sort_by { |rvp| rvp.first_name }
    @sorted_rvps = Rvp.order(:first_name) # This assumes you have 'first_name' field in Rvp model
  end
  
  #I need to remember what this does.
  def upload
    @user = User.new
    @user.avatar.attach(params[:avatar])
    @user.save
  end
end
