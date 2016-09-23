class ChangeColumnNameInPokemons < ActiveRecord::Migration[5.0]
  def change
    rename_column :pokemons, :candies, :candy
  end
end
