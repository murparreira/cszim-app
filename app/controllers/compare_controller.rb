class CompareController < ApplicationController
  layout 'application_reduzido'

  def index
  end

  def compare_players
    players = params[:players]
    season_id = params[:season_id]
    tournament_id = params[:tournament_id]
    map_id = params[:map_id]
    fields = "nome, SUM(score) AS score, SUM(kills) AS kills, SUM(deaths) AS deaths, SUM(suicides) AS suicides, SUM(tk) AS tk, SUM(shots) AS shots, SUM(hits) AS hits, SUM(headshots) AS headshots, SUM(connected) AS connected, SUM(rounds_tr) AS rounds_tr, SUM(rounds_ct) AS rounds_ct, SUM(lastconnect) AS lastconnect, SUM(knife) AS knife, SUM(glock) AS glock, SUM(usp ) AS usp , SUM(p228) AS p228, SUM(deagle) AS deagle, SUM(elite) AS elite, SUM(fiveseven) AS fiveseven, SUM(m3) AS m3, SUM(xm1014) AS xm1014, SUM(mac10) AS mac10, SUM(tmp ) AS tmp , SUM(mp5navy) AS mp5navy, SUM(ump45) AS ump45, SUM(p90 ) AS p90 , SUM(galil) AS galil, SUM(ak47) AS ak47, SUM(sg550) AS sg550, SUM(famas) AS famas, SUM(m4a1) AS m4a1, SUM(aug ) AS aug , SUM(scout) AS scout, SUM(sg552) AS sg552, SUM(awp ) AS awp , SUM(g3sg1) AS g3sg1, SUM(m249) AS m249, SUM(hegrenade) AS hegrenade, SUM(flashbang) AS flashbang, SUM(smokegrenade) AS smokegrenade, SUM(head) AS head, SUM(chest) AS chest, SUM(stomach) AS stomach, SUM(left_arm) AS left_arm, SUM(right_arm) AS right_arm, SUM(left_leg) AS left_leg, SUM(right_leg) AS right_leg, SUM(c4_planted) AS c4_planted, SUM(c4_exploded) AS c4_exploded, SUM(c4_defused) AS c4_defused, SUM(ct_win) AS ct_win, SUM(tr_win) AS tr_win, SUM(hostages_rescued) AS hostages_rescued, SUM(vip_killed) AS vip_killed, SUM(vip_escaped) AS vip_escaped, SUM(vip_played) AS vip_played"
    if players.present?
      @ranks = Rankme.joins(:user).select(fields).where("user_id IN (?)", players).group(:user_id, :nome)
      if season_id.present? && tournament_id.blank? && map_id.blank?
        @ranks = Rankme.joins(:user).select(fields).where("user_id IN (?) AND season_id = ?", players, season_id).group(:user_id, :nome)
      end
      if season_id.present? && tournament_id.present? && map_id.blank?
        @ranks = Rankme.joins(:user).select(fields).where("user_id IN (?) AND season_id = ? AND tournament_id = ?", players, season_id, tournament_id).group(:user_id, :nome)
      end
      if season_id.present? && tournament_id.blank? && map_id.present?
        @ranks = Rankme.joins(:user).select(fields).where("user_id IN (?) AND season_id = ? AND map_id = ?", players, season_id, map_id).group(:user_id, :nome)
      end
      if season_id.present? && tournament_id.present? && map_id.present?
        @ranks = Rankme.joins(:user).select(fields).where("user_id IN (?) AND season_id = ? AND tournament_id = ? AND map_id = ?", players, season_id, tournament_id, map_id).group(:user_id, :nome)
      end
      if season_id.blank? && tournament_id.present? && map_id.blank?
        @ranks = Rankme.joins(:user).select(fields).where("user_id IN (?) AND tournament_id = ?", players, tournament_id).group(:user_id, :nome)
      end
      if season_id.blank? && tournament_id.blank? && map_id.present?
        @ranks = Rankme.joins(:user).select(fields).where("user_id IN (?) AND map_id = ?", players, map_id).group(:user_id, :nome)
      end
      if season_id.blank? && tournament_id.present? && map_id.present?
        @ranks = Rankme.joins(:user).select(fields).where("user_id IN (?) AND tournament_id = ? AND map_id = ?", players, tournament_id, map_id).group(:user_id, :nome)
      end
    else
      @ranks = []
    end
    render layout: false
  end

  def get_maps_from_tournament
    map_ids = Rankme.where(tournament_id: params[:tournament_id]).pluck(:map_id).uniq
    hash = []
    map_ids.each do |map_id|
      hash << { id: map_id, nome: Map.find(map_id).nome }
    end
    render json: hash
  end

  def get_tournaments_from_season
    tournament_ids = Tournament.where(season_id: params[:season_id]).pluck(:id).uniq
    hash = []
    tournament_ids.each do |tournament_id|
      hash << { id: tournament_id, nome: Tournament.find(tournament_id).nome }
    end
    render json: hash
  end

end
