class CreateStatistics < ActiveRecord::Migration[5.0]
  def change
    create_table :statistics do |t|
      t.belongs_to :round, index: true
      t.belongs_to :user, index: true
      t.belongs_to :team, index: true
      t.integer :kills
      t.integer :deaths
      
      t.timestamps
    end
  end
end
