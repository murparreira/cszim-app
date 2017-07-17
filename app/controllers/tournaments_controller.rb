class TournamentsController < ApplicationController
    before_action :authenticate_user

	def index
		@tournaments = Tournament.order(id: :desc)
	end

	def edit
    @tournament = Tournament.find(params[:id])
    authorize @tournament
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def update
    @tournament = Tournament.find(params[:id])
    authorize @tournament
    if @tournament.update_attributes(tournament_params)
      flash[:success] = 'Torneio atualizado com sucesso!'
      redirect_to tournaments_url
    else
      render 'edit'
    end
  end

  def new
    @tournament = Tournament.new
    authorize @tournament
    participante_um = Participant.new
    participante_dois = Participant.new
    @tournament.participants << participante_um
    @tournament.participants << participante_dois
    participante_um.build_team
    participante_dois.build_team
  end

  def create
    @tournament = Tournament.new(tournament_params)
    authorize @tournament

    ActiveRecord::Base.transaction do

      if params[:times_automatico]
        @tournament.participants.delete_all
        team_one = Team.create
        team_two = Team.create
        user_array = User.all.shuffle.each_slice(3).to_a
        team_one.users << user_array.first
        team_two.users << user_array.last
        @tournament.teams << team_one
        @tournament.teams << team_two
      end

      raise ActiveRecord::Rollback unless @tournament.save

      if params[:automatico]
        maps = Map.ativos.pluck(:id)
        map_bans = @tournament.map_bans.pluck(:map_id)
        final_maps = maps - map_bans

        if params[:numero_maximo_mapas]
          if params[:numero_maximo_mapas].to_i <= 0
            @tournament.errors.add(:erro_maximo_mapas, "O número máximo de mapas deve ser maior que 1 (um)")
            raise ActiveRecord::Rollback
          end
          final_maps = final_maps.sample(params[:numero_maximo_mapas].to_i)
        end

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
    end

    respond_to :js
  end

	private

  def tournament_params
    params.require(:tournament).permit(:nome, :oficial, map_bans_attributes: [:id, :map_id, :_destroy], participants_attributes: [:id, :_destroy, team_attributes: [:nome, players_attributes: [:id, :user_id, :_destroy]]])
  end
end
