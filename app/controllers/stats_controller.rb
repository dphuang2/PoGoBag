class StatsController < ApplicationController
  def show
    @pokemon_cp = Pokemon.order(cp: :desc, iv: :desc, max_health: :desc).limit(100)
    @pokemon_health = Pokemon.order(max_health: :desc, cp: :desc, iv: :desc).limit(100)
    @pokemon_attack = Pokemon.order(battles_attacked: :desc, cp: :desc, iv: :desc).limit(100)
    @pokemon_defend = Pokemon.order(battles_defended: :desc, cp: :desc, iv: :desc).limit(100)
    @pokemon_upgrade = Pokemon.order(num_upgrades: :desc, cp: :desc, iv: :desc).limit(100)
    @pokemon_height = Pokemon.order(height_m: :desc, cp: :desc, iv: :desc).limit(100)
    @pokemon_weight = Pokemon.order(weight_kg: :desc, cp: :desc, iv: :desc).limit(100)
  end
end
