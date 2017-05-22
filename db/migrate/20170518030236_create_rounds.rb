class CreateRounds < ActiveRecord::Migration[5.0]
  def change
    create_table :rounds do |t|
      t.integer :ct_team_id
      t.integer :t_team_id
      t.belongs_to :tournament, index: true
      t.belongs_to :map, index: true
      t.integer :pontos, default: 3
      t.string :screenshot_uid
      t.string :screenshot_name
      t.date :data_round

      t.timestamps
    end
  end
end
