class MapsController < ApplicationController
    before_action :authenticate_user

	def index
    if params[:game_id]
      @maps = Map.where(game_id: params[:game_id])      
    else
      @maps = Map.order(:nome)
    end
	end

	def edit
    @map = Map.find(params[:id])
    authorize @map
  end

  def update
    @map = Map.find(params[:id])
    authorize @map
    if @map.update_attributes(map_params)
      flash[:success] = 'Mapa atualizado com sucesso!'
      redirect_to maps_url
    else
      render 'edit'
    end
  end

  def new
    @map = Map.new
    authorize @map
  end

  def create
    @map = Map.new(map_params)
    authorize @map
    @map.ativo = true
    if @map.save
      flash[:success] = 'Mapa criado com sucesso!'
      redirect_to maps_url
    else
      render 'new'
    end
  end

  def toggle_status
    @map = Map.find params[:id]
    @map.toggle :ativo
    @map.save
    respond_to :js
  end

	private

  def map_params
    params.require(:map).permit(:nome, :sigla, :imagem, :game_id)
  end
end
