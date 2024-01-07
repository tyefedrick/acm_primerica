class PagesController < ApplicationController
    def index
    end
    
    def upload
        @user = User.new
        @user.avatar.attach(params[:avatar])
        @user.save
      end
end
