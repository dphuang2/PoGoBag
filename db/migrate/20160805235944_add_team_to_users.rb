class AddTeamToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :team, :string
  end
end
