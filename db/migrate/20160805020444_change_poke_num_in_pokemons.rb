class ChangePokeNumInPokemons < ActiveRecord::Migration[5.0]
  def change
    change_column :pokemons, :poke_num, :integer
  end
end
