class DashboardController < ApplicationController
  def index
    render "#{current_configuration.version}/dashboard/index"
  end
end
