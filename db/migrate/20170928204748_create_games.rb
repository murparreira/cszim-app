class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.string :nome
      t.boolean :ativo, default: false
      t.timestamps null: false
    end
  end
end
