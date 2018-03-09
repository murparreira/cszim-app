class AddSeasonIdOnTables < ActiveRecord::Migration[5.0]
  def change
    add_column :rounds, :season_id, :integer
    add_column :tournaments, :season_id, :integer
    add_column :rankmes, :season_id, :integer
  end
end
