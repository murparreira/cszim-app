class CreateSeasons < ActiveRecord::Migration[5.0]
  def change
    create_table :seasons do |t|
      t.string :nome
      t.timestamps null: false
    end
  end
end
