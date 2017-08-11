class AddSteamToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :steam, :string
    execute "UPDATE users SET steam = 'STEAM_0:1:18018710' WHERE id = 1;"
    execute "UPDATE users SET steam = 'STEAM_0:0:145313615' WHERE id = 2;"
    execute "UPDATE users SET steam = 'STEAM_0:0:195402142' WHERE id = 5;"
    execute "UPDATE users SET steam = 'STEAM_0:1:35250772' WHERE id = 7;"
  end
end
