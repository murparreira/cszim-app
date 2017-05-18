class CreateWinners < ActiveRecord::Migration[5.0]
  def change
    create_table :winners do |t|
      t.belongs_to :round, index: true
      t.belongs_to :team, index: true
      t.integer :placar
      t.string :lado

      t.timestamps
    end
  end
end
