class AddRoundIdToRankMes < ActiveRecord::Migration[5.0]
  def change
  	add_column :rankmes, :round_id, :integer
  end
end
