class CreateMaps < ActiveRecord::Migration[5.0]
  def change
    create_table :maps do |t|
      t.string :nome
      t.string :sigla
      t.string :imagem_uid
      t.string :imagem_name
      t.boolean :ativo, default: true

      t.timestamps
    end
  end
end
