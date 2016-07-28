class CreatePokemons < ActiveRecord::Migration[5.0]
  def change
    create_table :pokemons do |t|
      t.string :poke_id
      t.string :move_1
      t.string :move_2
      t.integer :health
      t.integer :attack
      t.integer :defense
      t.integer :stamina
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
