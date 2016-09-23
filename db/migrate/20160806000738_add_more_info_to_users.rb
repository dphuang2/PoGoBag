class AddMoreInfoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :max_pokemon_storage, :string
    add_column :users, :max_item_storage, :string
    add_column :users, :POKECOIN, :float
    add_column :users, :STARDUST, :float
  end
end
