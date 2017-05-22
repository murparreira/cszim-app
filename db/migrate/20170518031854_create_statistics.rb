class CreateStatistics < ActiveRecord::Migration[5.0]
  def change
    create_table :statistics do |t|
      t.belongs_to :round, index: true
      t.belongs_to :user, index: true
      t.belongs_to :team, index: true
      t.integer :kills, default: 0
      t.integer :deaths, default: 0

      t.timestamps
    end
  end
end
