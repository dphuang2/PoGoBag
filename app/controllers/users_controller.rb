class UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::StatementInvalid, with: :direct_to_default

  def index
    @users = User.trainer_search(params[:search]).
      order(created_at: :desc).
      paginate(page: params[:page])
  end

  def show
    @user = User.find_by(name: params[:id]) || User.find(params[:id])

    if params[:refresh]
      if @user.refresh_token != nil
        if @user.access_token_expire_time > Time.now.to_i
          refresh_data(@user)
        else
          flash.now[:danger] = "#{@user.screen_name}'s token expired. #{@user.screen_name} must login to refresh his token."
        end
      else
        flash.now[:danger] = "#{@user.screen_name} is a PTC account. #{@user.screen_name} must login to refresh his Pokémon."
      end
    end

    if params[:stat]
      direction = %w(poke_num poke_id).include?(params[:stat]) ? 'ASC' : 'DESC'
      @pokemon = @user.pokemon.order("#{params[:stat]} #{direction}, cp DESC, iv DESC")
    else
      @pokemon = @user.pokemon.order("cp DESC")
    end
    fresh_when @user # Don't make database query unless user has been modified
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
