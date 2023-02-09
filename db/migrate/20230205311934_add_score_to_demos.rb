class AddScoreToDemos < ActiveRecord::Migration[5.0]
  def change
    add_column :demos, :score, :string
  end
end
