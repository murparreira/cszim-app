class RankmecsgoNewFields < ActiveRecord::Migration[5.0]
  def change
    add_column :rankme_csgos, :match_win, :integer
    add_column :rankme_csgos, :match_draw, :integer
    add_column :rankme_csgos, :match_lose, :integer
  end
end
