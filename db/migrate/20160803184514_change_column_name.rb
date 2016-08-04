class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :access_token, :id_token
  end
end
