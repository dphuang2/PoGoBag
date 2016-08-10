class StatsController < ApplicationController
  def show
    if params[:stat]
      @pokemon = Pokemon.order("#{params[:stat]} DESC, cp DESC, iv DESC")
    else
      @pokemon = Pokemon.order("cp DESC, iv DESC")
    end
  end
end
