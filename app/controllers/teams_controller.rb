class TeamsController < ApplicationController
    before_action :authenticate_user

	def index
		@teams = Team.order(:nome)
	end

	def edit
    @team = Team.find(params[:id])
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    flash[:success] = 'Time removido com sucesso!'
    redirect_to teams_url
  end

  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(team_params)
      flash[:success] = 'Time atualizado com sucesso!'
      redirect_to teams_url
    else
      render 'edit'
    end
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(team_params)
    @team.ativo = true
    if @team.save
      flash[:success] = 'Time criado com sucesso!'
      redirect_to teams_url
    else
      render 'new'
    end
  end

	private

  def team_params
    params.require(:team).permit(:nome, players_attributes: [:id, :user_id, :_destroy])
  end
end
