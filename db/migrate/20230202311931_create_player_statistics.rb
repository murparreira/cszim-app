class CreatePlayerStatistics < ActiveRecord::Migration[5.0]
  def change
    create_table :player_statistics do |t|
      t.float :accuracy
      t.float :adr
      t.integer :assists
      t.integer :attempts1v1
      t.integer :attempts1v2
      t.integer :attempts1v3
      t.integer :attempts1v4
      t.integer :attempts1v5
      t.float :blindTime
      t.integer :deaths
      t.integer :defuses
      t.integer :enemiesFlashed
      t.integer :fireThrown
      t.integer :firstDeaths
      t.integer :firstKills
      t.integer :flashAssists
      t.integer :flashesThrown
      t.integer :heThrown
      t.integer :hs
      t.float :hsPercent
      t.float :kast
      t.float :kdr
      t.integer :kills
      t.integer :kills0
      t.integer :kills1
      t.integer :kills2
      t.integer :kills3
      t.integer :kills4
      t.integer :kills5
      t.integer :plants
      t.float :rating
      t.integer :shotsHit
      t.integer :smokesThrown
      t.integer :success1v1
      t.integer :success1v2
      t.integer :success1v3
      t.integer :success1v4
      t.integer :success1v5
      t.integer :suicides
      t.integer :teamKills
      t.integer :teammatesFlashed
      t.integer :totalDamageGiven
      t.integer :totalDamageTaken
      t.integer :totalRounds
      t.integer :totalShots
      t.integer :totalTeamDamageGiven
      t.integer :tradeKills
      t.integer :tradedDeaths
      t.integer :utilityDamage
      t.references :user
      t.references :demo

      t.timestamps null: false
    end
  end
end
