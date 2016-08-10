class StatsController < ApplicationController
  def show
    if params[:stat]
      @pokemon = Pokemon.order("#{params[:stat]} DESC, cp DESC, iv DESC").limit(100).includes(:user)
    else
      @pokemon = Pokemon.order("cp DESC, iv DESC").limit(100).includes(:user)
    end
  end
end
