class RenameAliasToScreenNameInUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :alias, :screen_name
  end
end
