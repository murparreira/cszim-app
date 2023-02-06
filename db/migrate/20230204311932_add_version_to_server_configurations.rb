class AddVersionToServerConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :server_configurations, :version, :string
  end
end
