class RoundsController < ApplicationController
  before_action :authenticate_user

	def edit
    @tournament = Tournament.find(params[:tournament_id])
    @round = Round.find(params[:id])
  end

  def update
    @tournament = Round.find(params[:id])
    if @tournament.update_attributes(tournament_params)
      flash[:success] = 'Round atualizado com sucesso!'
      redirect_to tournaments_url
    else
      render 'edit'
    end
  end

  def new
    @tournament = Tournament.find(params[:tournament_id])
    @round = @tournament.rounds.build
  end

  def create
    round = Round.new(round_params)
    round.tournament_id = params[:tournament_id]
    round.save

    tournament = Tournament.find(params[:tournament_id])
    tournament.teams.each do |team|
      if params[:winner_team_id].to_i == team.id
        Winner.create(team_id: team.id, round_id: round.id, placar: params[:placar_vencedor], lado: params[:lado_vencedor])
      else
        Loser.create(team_id: team.id, round_id: round.id, placar: params[:placar_perdedor], lado: Lists.lado_perdedor(params[:lado_vencedor]))
      end
    end

    params[:statistics].each do |team_id, team_values|
      team_values.each do |user_id, user_values|
        statistic = Statistic.new(user_values)
        statistic.round_id = round.id
        statistic.team_id = team_id
        statistic.user_id = user_id
        statistic.save
      end
    end

    redirect_to tournament

  end

	private

  def round_params
    params.require(:round).permit(:map_id)
  end
end
