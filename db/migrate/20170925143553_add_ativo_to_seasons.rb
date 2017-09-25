class AddAtivoToSeasons < ActiveRecord::Migration[5.0]
  def change
    add_column :seasons, :ativo, :boolean, default: true
  end
end
