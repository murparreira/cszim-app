class TournamentsController < ApplicationController
    before_action :authenticate_user

	def index
		@tournaments = Tournament.order(:nome)
	end

	def edit
    @tournament = Tournament.find(params[:id])
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def destroy
    @tournament = Tournament.find(params[:id])
    @tournament.destroy
    flash[:success] = 'Time removido com sucesso!'
    redirect_to tournaments_url
  end

  def update
    @tournament = Tournament.find(params[:id])
    if @tournament.update_attributes(tournament_params)
      flash[:success] = 'Time atualizado com sucesso!'
      redirect_to tournaments_url
    else
      render 'edit'
    end
  end

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_params)
    if @tournament.save
      flash[:success] = 'Time criado com sucesso!'
      redirect_to tournaments_url
    else
      render 'new'
    end
  end

	private

  def tournament_params
    params.require(:tournament).permit(:nome, participants_attributes: [:id, :team_id, :_destroy])
  end
end
