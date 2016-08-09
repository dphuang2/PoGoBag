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

    if params[:refresh]
      if @user.refresh_token != nil
        if @user.access_token_expire_time > Time.now.to_i
          refresh_data(@user) 
        else
          flash.now[:danger] = @user.screen_name+"'s token expired. "+@user.screen_name+" must login to refresh his token."
        end
      else
        flash.now[:danger] = @user.screen_name+' is a PTC account. '+@user.screen_name+' must login to refresh his Pokémon.'
      end
    end
    @pokemon_cp = @user.pokemon.order("cp DESC")
    @pokemon_iv = @user.pokemon.order("iv DESC")
    @pokemon_recent = @user.pokemon.order("creation_time_ms DESC")
    @pokemon_health = @user.pokemon.order("max_health DESC")
    @pokemon_atk = @user.pokemon.order("attack DESC")
    @pokemon_def = @user.pokemon.order("defense DESC")
    @pokemon_sta = @user.pokemon.order("stamina DESC")
    @pokemon_name = @user.pokemon.order("poke_id DESC")
    @pokemon_num = @user.pokemon.order("poke_num DESC")
    @pokemon_attack = @user.pokemon.order("battles_attacked DESC")
    @pokemon_defend = @user.pokemon.order("battles_defended DESC")
    @pokemon_height = @user.pokemon.order("height_m DESC")
    @pokemon_weight = @user.pokemon.order("weight_kg DESC")
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
