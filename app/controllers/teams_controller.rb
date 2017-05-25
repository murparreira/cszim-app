class TeamsController < ApplicationController
    before_action :authenticate_user

	def index
		@teams = Team.order(:nome)
	end

	def edit
    @team = Team.find(params[:id])
    authorize @team
  end

  def update
    @team = Team.find(params[:id])
    authorize @team
    if @team.update_attributes(team_params)
      flash[:success] = 'Time atualizado com sucesso!'
      redirect_to teams_url
    else
      render 'edit'
    end
  end

  def new
    @team = Team.new
    authorize @team
  end

  def create
    @team = Team.new(team_params)
    authorize @team
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
