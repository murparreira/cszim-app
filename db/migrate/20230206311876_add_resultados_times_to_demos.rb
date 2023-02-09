class AddResultadosTimesToDemos < ActiveRecord::Migration[5.0]
  def change
    add_reference :demos, :time_vencedor, foreign_key: { to_table: :teams }
    add_reference :demos, :time_perdedor, foreign_key: { to_table: :teams }
  end
end
