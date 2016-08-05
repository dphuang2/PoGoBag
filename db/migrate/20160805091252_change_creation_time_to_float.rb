class ChangeCreationTimeToFloat < ActiveRecord::Migration[5.0]
  def change
    remove_column :pokemons, :creation_time_ms
    add_column :pokemons, :creation_time_ms, :float
  end
end
