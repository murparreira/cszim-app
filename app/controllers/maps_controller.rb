class MapsController < ApplicationController
    before_action :authenticate_user

	def index
		@maps = Map.order(:nome)
	end

	def edit
    @map = Map.find(params[:id])
  end

  def destroy
    @map = Map.find(params[:id])
    @map.destroy
    flash[:success] = 'Mapa removido com sucesso!'
    redirect_to maps_url
  end

  def update
    @map = Map.find(params[:id])
    if @map.update_attributes(map_params)
      flash[:success] = 'Mapa atualizado com sucesso!'
      redirect_to maps_url
    else
      render 'edit'
    end
  end

  def new
    @map = Map.new
  end

  def create
    @map = Map.new(map_params)
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
    params.require(:map).permit(:nome, :sigla, :imagem)
  end
end
