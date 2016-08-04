class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  def show
    if @user = User.find_by(name: params[:id]) 
    else
      @user = User.find(params[:id])
    end
  end

  def refresh
  end

  private 
    def not_found
      if logged_in?
        redirect_to user_link
      else
        redirect_to root_path
      end
      flash[:danger] = 'The player you are looking for does not exist (Trainers have to log into PoGoBag to be seen)'
    end
end
