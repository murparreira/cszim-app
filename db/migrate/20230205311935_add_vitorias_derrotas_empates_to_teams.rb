class AddVitoriasDerrotasEmpatesToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :vitorias, :integer, default: 0
    add_column :teams, :derrotas, :integer, default: 0
    add_column :teams, :empates, :integer, default: 0
  end
end
