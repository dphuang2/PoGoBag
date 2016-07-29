class UsersController < ApplicationController
  def show

    if @user = User.find_by(name: params[:id]) 
    else
      @user = User.find(params[:id])
    end

    @items = @user.items.all
    @pokemon = @user.pokemon.all
  end

  def refresh
  end
end
