class CompareController < ApplicationController
  layout 'application_reduzido'

  def index
  end

  def compare_players
    players = params[:players]
    game_id = params[:game_id]
    season_id = params[:season_id]
    tournament_id = params[:tournament_id]
    map_id = params[:map_id]

    if players.present?
      if game_id.present?
        game = Game.find(game_id)
        if game.sigla == "CSGO"
          @ranks = RankmeCsgo.select_fields
        else
          @ranks = Rankme.select_fields
        end
        @ranks = @ranks.by_players(players)
        if season_id.present? && tournament_id.blank? && map_id.blank?
          @ranks = @ranks.by_players(players).where("season_id = ?", season_id).group(:user_id, :nome)
        end
        if season_id.present? && tournament_id.present? && map_id.blank?
          @ranks = @ranks.by_players(players).where("season_id = ? AND tournament_id = ?", season_id, tournament_id).group(:user_id, :nome)
        end
        if season_id.present? && tournament_id.blank? && map_id.present?
          @ranks = @ranks.by_players(players).where("season_id = ? AND map_id = ?", season_id, map_id).group(:user_id, :nome)
        end
        if season_id.present? && tournament_id.present? && map_id.present?
          @ranks = @ranks.by_players(players).where("season_id = ? AND tournament_id = ? AND map_id = ?", season_id, tournament_id, map_id).group(:user_id, :nome)
        end
        if season_id.blank? && tournament_id.present? && map_id.blank?
          @ranks = @ranks.by_players(players).where("tournament_id = ?", tournament_id).group(:user_id, :nome)
        end
        if season_id.blank? && tournament_id.blank? && map_id.present?
          @ranks = @ranks.by_players(players).where("map_id = ?", map_id).group(:user_id, :nome)
        end
        if season_id.blank? && tournament_id.present? && map_id.present?
          @ranks = @ranks.by_players(players).where("tournament_id = ? AND map_id = ?", tournament_id, map_id).group(:user_id, :nome)
        end
      else
        @ranks_csgo = RankmeCsgo.select_fields
        @ranks_css = Rankme.select_fields
        @ranks_csgo = @ranks_csgo.by_players(players)
        @ranks_css = @ranks_css.by_players(players)
        if season_id.present? && tournament_id.blank? && map_id.blank?
          @ranks_csgo = @ranks_csgo.by_players(players).where("season_id = ?", season_id).group(:user_id, :nome)
          @ranks_css = @ranks_css.by_players(players).where("season_id = ?", season_id).group(:user_id, :nome)
        end
        if season_id.present? && tournament_id.present? && map_id.blank?
          @ranks_csgo = @ranks_csgo.by_players(players).where("season_id = ? AND tournament_id = ?", season_id, tournament_id).group(:user_id, :nome)
          @ranks_css = @ranks_css.by_players(players).where("season_id = ? AND tournament_id = ?", season_id, tournament_id).group(:user_id, :nome)
        end
        if season_id.present? && tournament_id.blank? && map_id.present?
          @ranks_csgo = @ranks_csgo.by_players(players).where("season_id = ? AND map_id = ?", season_id, map_id).group(:user_id, :nome)
          @ranks_css = @ranks_css.by_players(players).where("season_id = ? AND map_id = ?", season_id, map_id).group(:user_id, :nome)
        end
        if season_id.present? && tournament_id.present? && map_id.present?
          @ranks_csgo = @ranks_csgo.by_players(players).where("season_id = ? AND tournament_id = ? AND map_id = ?", season_id, tournament_id, map_id).group(:user_id, :nome)
          @ranks_css = @ranks_css.by_players(players).where("season_id = ? AND tournament_id = ? AND map_id = ?", season_id, tournament_id, map_id).group(:user_id, :nome)
        end
        if season_id.blank? && tournament_id.present? && map_id.blank?
          @ranks_csgo = @ranks_csgo.by_players(players).where("tournament_id = ?", tournament_id).group(:user_id, :nome)
          @ranks_css = @ranks_css.by_players(players).where("tournament_id = ?", tournament_id).group(:user_id, :nome)
        end
        if season_id.blank? && tournament_id.blank? && map_id.present?
          @ranks_csgo = @ranks_csgo.by_players(players).where("map_id = ?", map_id).group(:user_id, :nome)
          @ranks_css = @ranks_css.by_players(players).where("map_id = ?", map_id).group(:user_id, :nome)
        end
        if season_id.blank? && tournament_id.present? && map_id.present?
          @ranks_csgo = @ranks_csgo.by_players(players).where("tournament_id = ? AND map_id = ?", tournament_id, map_id).group(:user_id, :nome)
          @ranks_css = @ranks_css.by_players(players).where("tournament_id = ? AND map_id = ?", tournament_id, map_id).group(:user_id, :nome)
        end
        @ranks = @ranks_csgo + @ranks_css
      end
    else
      @ranks = []
    end

    render layout: false
  end

  def get_maps_from_tournament
    if params[:game_id].present?
      game = Game.find(params[:game_id])
      if game.sigla == "CSGO"
        map_ids = RankmeCsgo.where(tournament_id: params[:tournament_id]).pluck(:map_id).uniq
      else
        map_ids = Rankme.where(tournament_id: params[:tournament_id]).pluck(:map_id).uniq
      end
    else
      map_ids_css = Rankme.where(tournament_id: params[:tournament_id]).pluck(:map_id).uniq
      map_ids_csgo = RankmeCsgo.where(tournament_id: params[:tournament_id]).pluck(:map_id).uniq
      map_ids = map_ids_css + map_ids_csgo
    end
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
