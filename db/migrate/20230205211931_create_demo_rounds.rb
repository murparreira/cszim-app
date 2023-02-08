class CreateDemoRounds < ActiveRecord::Migration[5.0]
  def change
    create_table :demo_rounds do |t|
      t.integer :roundNum
      t.string :winningSide
      t.references :demo
      t.timestamps null: false
    end
  end
end
