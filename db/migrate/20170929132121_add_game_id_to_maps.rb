class AddGameIdToMaps < ActiveRecord::Migration[5.0]
  def change
    add_column :maps, :game_id, :integer
  end
end
