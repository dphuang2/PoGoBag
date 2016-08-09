class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from ActiveRecord::StatementInvalid, :with => :direct_to_default

  def index
    if params[:search]
      @users = User.search(params[:search]).order("created_at DESC").paginate(page: params[:page])
    else
      @users = User.all.order('created_at DESC').paginate(page: params[:page])
    end
  end

  def show
    if @user = User.find_by(name: params[:id]) 
    else
      @user = User.find(params[:id])
    end

    if @user.refresh_token != nil && @user.access_token_expire_time > Time.now.to_i && params[:refresh]
      refresh_data(@user) 
    else
      flash.now[:danger] = 'This user must log in again to refresh their page'
    end

    if params[:stat]
      direction = ' DESC'
      if params[:stat] == 'poke_num' || params[:stat] == 'poke_id'
        direction = ' ASC'
      end
      @pokemon = @user.pokemon.order(params[:stat]+direction+', cp DESC, iv DESC')
    else
      @pokemon = @user.pokemon.order("cp DESC")
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
    redirect_to '/'+params[:id]
  end
end
