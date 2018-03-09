class AddRoundIdToRankmeCsgos < ActiveRecord::Migration[5.0]
  def change
    add_column :rankme_csgos, :round_id, :integer
  end
end
