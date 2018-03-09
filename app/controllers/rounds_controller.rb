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

  def move_to_winner
    ActiveRecord::Base.transaction do
      round_id = params[:round_id]
      user_id = params[:user_id]
      round = Round.find(round_id)
      novo_time_perdedor_user_ids = round.loser.team.players.pluck(:user_id) - [user_id.to_i]
      novo_time_perdedor = Team.joins(:users).group('teams.id').having('SUM( CASE WHEN users.id in (?) THEN 1 ELSE -1 END ) = ?', novo_time_perdedor_user_ids, novo_time_perdedor_user_ids.size).last
      placar = round.loser.placar
      round.loser.destroy
      if novo_time_perdedor
        Loser.create(team_id: novo_time_perdedor.id, round_id: round.id, placar: placar)
      else
        novo_time_perdedor = Team.create(nome: "Time #{helpers.criar_nome_time(novo_time_perdedor_user_ids)}")
        novo_time_perdedor_user_ids.each do |user_id|
          Player.where(team_id: novo_time_perdedor.id, user_id: user_id).first_or_create
        end
        Loser.create(team_id: novo_time_perdedor.id, round_id: round.id, placar: placar)
      end
      novo_time_perdedor_user_ids.each do |user_id|
        RankmeCsgo.where(round_id: round.id, user_id: user_id).each { |r| r.update_attributes(team_id: novo_time_perdedor.id) }
      end
      novo_time_vencedor_user_ids = round.winner.team.players.pluck(:user_id) + [user_id.to_i]
      novo_time_vencedor = Team.joins(:users).group('teams.id').having('SUM( CASE WHEN users.id in (?) THEN 1 ELSE -1 END ) = ?', novo_time_vencedor_user_ids, novo_time_vencedor_user_ids.size).last
      placar = round.winner.placar
      round.winner.destroy
      if novo_time_vencedor
        Winner.create(team_id: novo_time_vencedor.id, round_id: round.id, placar: placar)
      else
        novo_time_vencedor = Team.create(nome: "Time #{helpers.criar_nome_time(novo_time_vencedor_user_ids)}")
        novo_time_vencedor_user_ids.each do |user_id|
          Player.where(team_id: novo_time_vencedor.id, user_id: user_id).first_or_create
        end
        Winner.create(team_id: novo_time_vencedor.id, round_id: round.id, placar: placar)
      end
      novo_time_vencedor_user_ids.each do |user_id|
        RankmeCsgo.where(round_id: round.id, user_id: user_id).each { |r| r.update_attributes(team_id: novo_time_vencedor.id) }
      end
      redirect_to tournament_path(id: params[:tournament_id])
    end
  end

  def move_to_loser
    ActiveRecord::Base.transaction do
      round_id = params[:round_id]
      user_id = params[:user_id]
      round = Round.find(round_id)
      novo_time_vencedor_user_ids = round.winner.team.players.pluck(:user_id) - [user_id.to_i]
      novo_time_vencedor = Team.joins(:users).group('teams.id').having('SUM( CASE WHEN users.id in (?) THEN 1 ELSE -1 END ) = ?', novo_time_vencedor_user_ids, novo_time_vencedor_user_ids.size).last
      placar = round.winner.placar
      round.winner.destroy
      if novo_time_vencedor
        Winner.create(team_id: novo_time_vencedor.id, round_id: round.id, placar: placar)
      else
        novo_time_vencedor = Team.create(nome: "Time #{helpers.criar_nome_time(novo_time_vencedor_user_ids)}")
        novo_time_vencedor_user_ids.each do |user_id|
          Player.where(team_id: novo_time_vencedor.id, user_id: user_id).first_or_create
        end
        Winner.create(team_id: novo_time_vencedor.id, round_id: round.id, placar: placar)
      end
      novo_time_vencedor_user_ids.each do |user_id|
        RankmeCsgo.where(round_id: round.id, user_id: user_id).each { |r| r.update_attributes(team_id: novo_time_vencedor.id) }
      end
      novo_time_perdedor_user_ids = round.loser.team.players.pluck(:user_id) + [user_id.to_i]
      novo_time_perdedor = Team.joins(:users).group('teams.id').having('SUM( CASE WHEN users.id in (?) THEN 1 ELSE -1 END ) = ?', novo_time_perdedor_user_ids, novo_time_perdedor_user_ids.size).last
      placar = round.loser.placar
      round.loser.destroy
      if novo_time_perdedor
        Loser.create(team_id: novo_time_perdedor.id, round_id: round.id, placar: placar)
      else
        novo_time_perdedor = Team.create(nome: "Time #{helpers.criar_nome_time(novo_time_perdedor_user_ids)}")
        novo_time_perdedor_user_ids.each do |user_id|
          Player.where(team_id: novo_time_perdedor.id, user_id: user_id).first_or_create
        end
        Loser.create(team_id: novo_time_perdedor.id, round_id: round.id, placar: placar)
      end
      novo_time_perdedor_user_ids.each do |user_id|
        RankmeCsgo.where(round_id: round.id, user_id: user_id).each { |r| r.update_attributes(team_id: novo_time_perdedor.id) }
      end
      redirect_to tournament_path(id: params[:tournament_id])
    end
  end

	private

  def round_params
    params.require(:round).permit(:map_id, :pontos, :screenshot)
  end
end
