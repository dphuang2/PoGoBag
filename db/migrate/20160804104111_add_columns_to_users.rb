class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :alias, :string
    add_column :users, :level, :integer
    add_column :users, :experience, :integer
    add_column :users, :prev_level_xp, :integer
    add_column :users, :next_level_xp, :integer
    add_column :users, :pokemons_encountered, :integer
    add_column :users, :km_walked, :decimal
    add_column :users, :pokemons_captured, :integer
    add_column :users, :poke_stop_visits, :integer
    add_column :users, :pokeballs_thrown, :integer
    add_column :users, :battle_attack_won, :integer
    add_column :users, :battle_attack_total, :integer
    add_column :users, :battle_defended_won, :integer
    add_column :users, :prestige_rasied_total, :integer
  end
end
