class AddDataToRankmeCsgos < ActiveRecord::Migration[5.0]
  def change
    add_column :rankme_csgos, :team_id, :integer
    add_column :rankme_csgos, :season_id, :integer
  end
end
