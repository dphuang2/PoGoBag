class ChangeColumnNameInUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :refresh_token_expire_time
    add_column :users, :access_token_expire_time, :float
  end
end
