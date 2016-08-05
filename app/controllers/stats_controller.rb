class StatsController < ApplicationController
  def show
    @pokemon_cp = Pokemon.order(cp: :desc).limit(100)
    @pokemon_iv = Pokemon.order(iv: :desc).order(cp: :desc).limit(100)
    @pokemon_won = Pokemon.order(battles_attacked: :desc).order(cp: :desc).limit(100)
  end
end
