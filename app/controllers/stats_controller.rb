class StatsController < ApplicationController
  def show
    @pokemon_cp = Pokemon.order(cp: :desc, iv: :desc).limit(100).includes(:user)
    @pokemon_health = Pokemon.order(max_health: :desc, cp: :desc).limit(100).includes(:user)
    @pokemon_attack = Pokemon.order(battles_attacked: :desc, cp: :desc).limit(100).includes(:user)
    @pokemon_defend = Pokemon.order(battles_defended: :desc, cp: :desc).limit(100).includes(:user)
    @pokemon_upgrade = Pokemon.order(num_upgrades: :desc, cp: :desc).limit(100).includes(:user)
    @pokemon_height = Pokemon.order(height_m: :desc, cp: :desc).limit(100).includes(:user)
    @pokemon_weight = Pokemon.order(weight_kg: :desc, cp: :desc).limit(100).includes(:user)
  end
end
