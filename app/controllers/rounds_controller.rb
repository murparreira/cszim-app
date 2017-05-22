class RoundsController < ApplicationController
  before_action :authenticate_user

	def edit
    @tournament = Tournament.find(params[:tournament_id])
    @round = Round.find(params[:id])
  end

  def update
    tournament = Tournament.find(params[:tournament_id])
    round = Round.find(params[:id])
    round.update_attributes(round_params)

    if round.winner
      round.winner.update_attributes(placar: params[:placar_vencedor], lado: params[:lado_vencedor])
    else
      Winner.create(team_id: params[:winner_team_id], round_id: round.id, placar: params[:placar_vencedor], lado: params[:lado_vencedor]) if params[:winner_team_id].present?
    end

    if round.loser
      round.loser.update_attributes(placar: params[:placar_perdedor], lado: Lists.lado_perdedor(params[:lado_vencedor]))
    else
      Loser.create(team_id: round.loser_team_id(params[:winner_team_id]), round_id: round.id, placar: params[:placar_perdedor], lado: Lists.lado_perdedor(params[:lado_vencedor])) if params[:winner_team_id].present?
    end

    params[:statistics].each do |id, statistic_values|
      statistic = Statistic.find(id)
      statistic.update_attributes(statistic_values)
    end

    redirect_to tournament
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
    if params[:winner_team_id].present?
      tournament.teams.each do |team|
        if params[:winner_team_id].to_i == team.id
          Winner.create(team_id: team.id, round_id: round.id, placar: params[:placar_vencedor], lado: params[:lado_vencedor])
        else
          Loser.create(team_id: team.id, round_id: round.id, placar: params[:placar_perdedor], lado: Lists.lado_perdedor(params[:lado_vencedor]))
        end
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
    params.require(:round).permit(:map_id, :pontos, :screenshot)
  end
end
