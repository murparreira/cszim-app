class AddSiglaLoginToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :sigla, :string
    add_column :games, :login, :string
  end
end
