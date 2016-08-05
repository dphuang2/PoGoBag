class AddRecencyToPokemons < ActiveRecord::Migration[5.0]
  def change
    add_column :pokemons, :creation_time_ms, :integer
    add_column :pokemons, :candies, :integer
    add_column :users, :pokemon_deployed, :integer
    add_column :users, :prestige_dropped_total, :integer
    add_column :users, :eggs_hatched, :integer
    add_column :users, :evolutions, :integer
    add_column :users, :unique_pokedex_entries, :integer
  end
end
