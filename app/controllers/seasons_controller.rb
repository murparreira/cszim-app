class SeasonsController < ApplicationController
    before_action :authenticate_user

	def index
		@seasons = Season.order(id: :desc)
	end

	def edit
    @season = Season.find(params[:id])
    authorize @season
  end

  def show
    @season = Season.find(params[:id])
  end

  def update
    @season = Season.find(params[:id])
    authorize @season
    if @season.update_attributes(season_params)
      flash[:success] = 'Temporada atualizada com sucesso!'
      redirect_to seasons_url
    else
      render 'edit'
    end
  end

  def new
    @season = Season.new
    authorize @season
  end

  def create
    @season = Season.new(season_params)
    authorize @season
    if @season.save
      Season.where.not(id: @season.id).update_all(ativo: false)
      flash[:success] = 'Temporada criado com sucesso!'
      redirect_to seasons_url
    else
      render 'new'
    end
  end

	private

  def season_params
    params.require(:season).permit(:nome)
  end
end
