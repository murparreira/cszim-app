class AddMoreAttributesToServerConfigurations < ActiveRecord::Migration[5.0]
  def change
    add_column :server_configurations, :server_name_or_ip, :text
    add_column :server_configurations, :server_port, :integer
    add_column :server_configurations, :server_password, :text
    add_column :server_configurations, :server_user, :text
  end
end
