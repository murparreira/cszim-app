class DemosController < ApplicationController
  before_action :authenticate_user
  
  def show
    @demo = Demo.find(params[:id])
  end
end
