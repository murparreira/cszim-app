class AddOficialToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :oficial, :boolean, default: false
  end
end
