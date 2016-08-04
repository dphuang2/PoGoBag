class AddColumnsToPokemons < ActiveRecord::Migration[5.0]
  def change
    add_column :pokemons, :nickname, :string
    add_column :pokemons, :favorite, :integer
    add_column :pokemons, :num_upgrades, :integer
    add_column :pokemons, :battles_attacked, :integer
    add_column :pokemons, :battles_defended, :integer
    add_column :pokemons, :pokeball, :string
    add_column :pokemons, :height_m, :decimal
    add_column :pokemons, :weight_kg, :decimal
    rename_column :pokemons, :health, :max_health
    add_column :pokemons, :health, :integer

  end
end
