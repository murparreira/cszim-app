class CreateDemoRoundKills < ActiveRecord::Migration[5.0]
  def change
    create_table :demo_round_kills do |t|
      t.integer :tick
      t.string :attackerSteamID
      t.string :attackerSide
      t.string :assisterSteamID
      t.string :assisterSide
      t.string :victimSteamID
      t.string :victimSide
      t.float :distance
      t.boolean :isWallbang
      t.boolean :noScope
      t.boolean :thruSmoke
      t.boolean :attackerBlinded
      t.boolean :victimBlinded
      t.string :weapon
      t.string :weaponClass
      t.references :demo_round

      t.timestamps null: false
    end
  end
end
