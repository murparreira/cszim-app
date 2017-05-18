class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.belongs_to :team, index: true
      t.belongs_to :tournament, index: true
    end
  end
end
