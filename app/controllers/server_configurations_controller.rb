class ServerConfigurationsController < ApplicationController
  before_action :authenticate_user

	def index
		@server_configurations = ServerConfiguration.order(id: :desc)
	end

	def edit
    @server_configuration = ServerConfiguration.find(params[:id])
  end

  def show
    @server_configuration = ServerConfiguration.find(params[:id])
  end

  def update
    @server_configuration = ServerConfiguration.find(params[:id])
    if @server_configuration.update_attributes(configuration_params)
      flash[:success] = 'Configuração atualizada com sucesso!'
      redirect_to server_configurations_url
    else
      render 'edit'
    end
  end

  def new
    @server_configuration = ServerConfiguration.new
  end

  def create
    @server_configuration = ServerConfiguration.new(configuration_params)
    if @server_configuration.save
      flash[:success] = 'Configuração criada com sucesso!'
      redirect_to server_configurations_url
    else
      render 'new'
    end
  end

  def toggle_status
    @server_configuration = ServerConfiguration.find params[:id]
    @server_configuration.toggle :ativo
    @server_configuration.save
    ServerConfiguration.where.not(id: params[:id]).update_all(ativo: false)
    respond_to :js
  end

	private

  def configuration_params
    params.require(:server_configuration).permit(:nome, :numero_partidas, :version)
  end
end
