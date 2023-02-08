class DemosController < ApplicationController
  before_action :authenticate_user

  def index
    @demos = Demo.all
  end

  def show
    @demo = Demo.find(params[:id])
  end
end
