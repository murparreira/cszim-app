class AddOldSteamToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :old_steam, :string
  end
end
