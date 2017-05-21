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
    flash[:success] = 'Torneio removido com sucesso!'
    redirect_to tournaments_url
  end

  def update
    @tournament = Tournament.find(params[:id])
    if @tournament.update_attributes(tournament_params)
      flash[:success] = 'Torneio atualizado com sucesso!'
      redirect_to tournaments_url
    else
      render 'edit'
    end
  end

  def new
    @tournament = Tournament.new
    participante_um = Participant.new
    participante_dois = Participant.new
    @tournament.participants << participante_um
    @tournament.participants << participante_dois
    participante_um.build_team
    participante_dois.build_team
  end

  def create
    @tournament = Tournament.new(tournament_params)
      respond_to do |format|
      if @tournament.save
        format.html { redirect_to @tournament, notice: 'Torneio criado com sucesso!' }
        format.js
        format.json { render json: @tournament, status: :created, location: @tournament }
      else
        # format.html { render action: "new" }
        format.json { render json: @tournament.errors, status: :unprocessable_entity }
      end
    end
  end

	private

  def tournament_params
    params.require(:tournament).permit(:nome, participants_attributes: [team_attributes: [:nome, players_attributes: [:id, :user_id, :_destroy]]])
  end
end
