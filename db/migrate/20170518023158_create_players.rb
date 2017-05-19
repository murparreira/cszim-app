class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.belongs_to :team, index: true
      t.belongs_to :user, index: true
    end
  end
end
