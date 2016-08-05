class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found

  def show
    if @user = User.find_by(name: params[:id]) 
    else
      @user = User.find(params[:id])
    end
    if params[:stat]
      direction = ' DESC'
      if params[:stat] == 'poke_num' || params[:stat] == 'poke_id'
        direction = ' ASC'
      end
      @pokemon = @user.pokemon.order(params[:stat]+direction+', cp DESC')
    else
      @pokemon = @user.pokemon
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
    def direct_to_default
      render '/'+params[:id]
    end
end
