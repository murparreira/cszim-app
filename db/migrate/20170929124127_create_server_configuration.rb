class CreateServerConfiguration < ActiveRecord::Migration[5.0]
  def change
    create_table :server_configurations do |t|
      t.string :nome
      t.string :numero_partidas
      t.boolean :ativo, default: false
      t.timestamps null: false
    end
  end
end
