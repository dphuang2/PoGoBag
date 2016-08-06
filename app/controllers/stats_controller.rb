class StatsController < ApplicationController
  def show
    @pokemon_cp = Pokemon.order(cp: :desc, iv: :desc, max_health: :desc).limit(100)
  end
end
