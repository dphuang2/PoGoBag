class RemoveLetsEncrypt < ActiveRecord::Migration[5.0]
  def change
    drop_table :letsencrypt_plugin_challenges
    drop_table :letsencrypt_plugin_settings
  end
end
