class AddRefreshTokenExpireTimeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :refresh_token_expire_time, :float
  end
end
