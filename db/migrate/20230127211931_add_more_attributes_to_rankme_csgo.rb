class AddMoreAttributesToRankmeCsgo < ActiveRecord::Migration[5.0]
  def change
    add_column :rankme_csgos, :mp5sd, :integer
    add_column :rankme_csgos, :breachcharge, :integer
    add_column :rankme_csgos, :first_blood, :integer
    add_column :rankme_csgos, :no_scope, :integer
    add_column :rankme_csgos, :no_scope_dis, :integer
    add_column :rankme_csgos, :thru_smoke, :integer
    add_column :rankme_csgos, :blind, :integer
    add_column :rankme_csgos, :assist_flash, :integer
    add_column :rankme_csgos, :assist_team_flash, :integer
    add_column :rankme_csgos, :assist_team_kill, :integer
    add_column :rankme_csgos, :wallbang, :integer
  end
end
