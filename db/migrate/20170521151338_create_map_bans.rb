class CreateMapBans < ActiveRecord::Migration[5.0]
  def change
    create_table :map_bans do |t|
      t.belongs_to :tournament, index: true
      t.belongs_to :map, index: true
    end
  end
end
