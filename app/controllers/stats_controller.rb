class StatsController < ApplicationController
  def show
    @pokemon_cp = Pokemon.order(cp: :desc).limit(10)
    @pokemon_iv = Pokemon.order(iv: :desc).limit(10)
  end
end
