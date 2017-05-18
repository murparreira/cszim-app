class CreateRounds < ActiveRecord::Migration[5.0]
  def change
    create_table :rounds do |t|
      t.belongs_to :tournament, index: true
      t.belongs_to :map, index: true

      t.timestamps
    end
  end
end
