class AddTeamdIdToRankMe < ActiveRecord::Migration[5.0]
  def change
  	add_column :rankmes, :team_id, :integer
  end
end
