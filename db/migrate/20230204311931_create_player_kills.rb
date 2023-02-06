class CreatePlayerKills < ActiveRecord::Migration[5.0]
  def change
    create_table :player_kills do |t|
      t.boolean :attackerBlinded
      t.string :attackerSide
      t.string :victimSteamID
      t.float :distance
      t.boolean :isFirstKill
      t.boolean :isWallbang
      t.boolean :noScope
      t.boolean :thruSmoke
      t.boolean :victimBlinded
      t.string :weapon
      t.string :weaponClass
      t.references :player_statistic

      t.timestamps null: false
    end
  end
end
