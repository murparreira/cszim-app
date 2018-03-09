class CreateRandomMaps < ActiveRecord::Migration[5.0]
  def change
    create_table :random_maps do |t|
      t.references :map, index: true

      t.timestamps
    end
  end
end
