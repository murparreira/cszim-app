class TournamentsController < ApplicationController
    before_action :authenticate_user

	def index
		@tournaments = Tournament.order(id: :desc)
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
    @tournament.save
    if params[:automatico]
      maps = Map.where(ativo: true).pluck(:id)
      map_bans = @tournament.map_bans.pluck(:map_id)
      final_maps = maps - map_bans
      final_maps.each do |map_id|
        round_ida = Round.create(tournament_id: @tournament.id, map_id: map_id, ct_team_id: @tournament.teams.first.id, t_team_id: @tournament.teams.last.id)

        @tournament.teams.each do |team|
          team.users.each do |user|
            statistic = Statistic.new
            statistic.round_id = round_ida.id
            statistic.team_id = team.id
            statistic.user_id = user.id
            statistic.save
          end
        end

        round_volta = Round.create(tournament_id: @tournament.id, map_id: map_id, ct_team_id: @tournament.teams.last.id, t_team_id: @tournament.teams.first.id)

        @tournament.teams.each do |team|
          team.users.each do |user|
            statistic = Statistic.new
            statistic.round_id = round_volta.id
            statistic.team_id = team.id
            statistic.user_id = user.id
            statistic.save
          end
        end

      end
    end
    respond_to :js
  end

	private

  def tournament_params
    params.require(:tournament).permit(:nome, map_bans_attributes: [:id, :map_id, :_destroy], participants_attributes: [team_attributes: [:nome, players_attributes: [:id, :user_id, :_destroy]]])
  end
end
