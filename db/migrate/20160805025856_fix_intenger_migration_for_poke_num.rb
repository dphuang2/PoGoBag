class FixIntengerMigrationForPokeNum < ActiveRecord::Migration[5.0]
  def change
    remove_column :pokemons, :poke_num, :integer
    add_column :pokemons, :poke_num, :integer
  end
end
