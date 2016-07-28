class UsersController < ApplicationController
  def show

    if @user = User.find_by(name: params[:id]) 
    else
      @user = User.find(params[:id])
    end

    @items = @user.items.paginate(page: params[:page])
    @pokemon = @user.pokemon.paginate(page: params[:page])
  end
end
