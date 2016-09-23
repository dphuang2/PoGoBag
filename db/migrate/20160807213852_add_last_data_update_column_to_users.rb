class AddLastDataUpdateColumnToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_data_update, :string
  end
end
