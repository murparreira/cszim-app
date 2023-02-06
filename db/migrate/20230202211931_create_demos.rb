class CreateDemos < ActiveRecord::Migration[5.0]
  def change
    create_table :demos do |t|
      t.string :nome
      t.references :map
      t.boolean :processada, default: false
      t.timestamps null: false
    end
  end
end
