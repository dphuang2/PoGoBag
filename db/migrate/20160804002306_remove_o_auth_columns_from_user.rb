class RemoveOAuthColumnsFromUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :provider
    remove_column :users, :uid
    remove_column :users, :oauth_token
    remove_column :users, :oauth_expires_at
    remove_column :users, :id_token
  end
end
