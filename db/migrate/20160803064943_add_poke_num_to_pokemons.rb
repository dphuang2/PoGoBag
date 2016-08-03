class AddPokeNumToPokemons < ActiveRecord::Migration[5.0]
  def change
    add_column :pokemons, :poke_num, :string
  end
end
