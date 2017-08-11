class RandomizerController < ApplicationController

  def index
    if session[:maps].nil?
      init_maps
    end
    if params[:start]      
      @torneio_dia = Tournament.find_by(nome: 'Torneio '+Date.today.strftime("%d/%m/%Y").to_s)
      if !@torneio_dia
        @tournament = Tournament.create(nome: 'Torneio '+Date.today.strftime("%d/%m/%Y").to_s)
        @torneio_dia = @tournament
        @team_one = Team.create(nome: 'Time 1 CT '+Date.today.strftime("%d/%m/%Y").to_s)
        @team_two = Team.create(nome: 'Time 2 TR '+Date.today.strftime("%d/%m/%Y").to_s)
        Participant.create(team_id: @team_one.id, tournament_id: @tournament.id)
        Participant.create(team_id: @team_two.id, tournament_id: @tournament.id)
        columns = RankmeMysql.columns.map(&:name)
        columns_to_update = columns - ["id", "steam", "name", "lastip"]
        columns_with_zero = columns_to_update.map { |c| [c, 0] }.to_h
        RankmeMysql.update_all columns_with_zero
        flash.now[:success] = "Torneio "+Date.today.strftime("%d/%m/%Y").to_s+" e mapa iniciado com sucesso!"
      else
        flash.now[:success] = "Mapa iniciado com sucesso!"
      end
    end
    if params[:finish]
      chosen_map = Map.find(session[:chosen_map])      
      @user = User.all
      @torneio_dia = Tournament.find_by(nome: 'Torneio '+Date.today.strftime("%d/%m/%Y").to_s)
      round = Round.create(tournament_id: @torneio_dia.id, map_id: chosen_map.id)
      @user.each do |u|
        if u.steam
          @rankme_mysql = RankmeMysql.find_by(:steam => u.steam)
          @team_one = Team.find_by(nome: 'Time 1 CT '+Date.today.strftime("%d/%m/%Y").to_s)
          @team_two = Team.find_by(nome: 'Time 2 TR '+Date.today.strftime("%d/%m/%Y").to_s)
          if @rankme_mysql.ct_win.to_i > 0 || @rankme_mysql.tr_win.to_i > 0
            rankme_attributes = @rankme_mysql.as_json.select{|k,v| k != 'id'}
            if @rankme_mysql.ct_win.to_i > 0
              rankme_attributes[:team_id] = @team_one.id
              Player.where(team_id: @team_one.id, user_id: u.id).first_or_create
            else
              rankme_attributes[:team_id] = @team_two.id
              Player.where(team_id: @team_two.id, user_id: u.id).first_or_create
            end
            rankme_attributes[:user_id] = u.id
            rankme_attributes[:map_id] = chosen_map.id
            rankme_attributes[:tournament_id] = @torneio_dia.id
            rankme_attributes[:round_id] = round.id
            @rankme_pg = Rankme.new(rankme_attributes)
            @rankme_pg.save
          end
        end
      end
      @rankme_mysql_ct = RankmeMysql.where('ct_win > 0').first
      @rankme_mysql_tr = RankmeMysql.where('tr_win > 0').first
      if @rankme_mysql_ct.ct_win == 7
        Winner.create(team_id: @team_one.id, round_id: round.id, placar: @rankme_mysql_ct.ct_win, lado: 'ct')
        Loser.create(team_id: @team_two.id, round_id: round.id, placar: @rankme_mysql_tr.tr_win, lado: 't')
      elsif @rankme_mysql_tr.tr_win == 7
        Winner.create(team_id: @team_two.id, round_id: round.id, placar: @rankme_mysql_tr.tr_win, lado: 't')
        Loser.create(team_id: @team_one.id, round_id: round.id, placar: @rankme_mysql_ct.ct_win, lado: 'ct')
      end
      columns = RankmeMysql.columns.map(&:name)
      columns_to_update = columns - ["id", "steam", "name", "lastip"]
      columns_with_zero = columns_to_update.map { |c| [c, 0] }.to_h
      RankmeMysql.update_all columns_with_zero
      flash.now[:warning] = "Mapa finalizado com sucesso!"
    end
    if params[:random] && session[:maps].any?      
      @torneio_dia = Tournament.find_by(nome: 'Torneio '+Date.today.strftime("%d/%m/%Y").to_s)
      if !@torneio_dia
        @tournament = Tournament.create(nome: 'Torneio '+Date.today.strftime("%d/%m/%Y").to_s)
        @torneio_dia = @tournament
        @team_one = Team.create(nome: 'Time 1 CT '+Date.today.strftime("%d/%m/%Y").to_s)
        @team_two = Team.create(nome: 'Time 2 TR '+Date.today.strftime("%d/%m/%Y").to_s)
        Participant.create(team_id: @team_one.id, tournament_id: @tournament.id)
        Participant.create(team_id: @team_two.id, tournament_id: @tournament.id)
        columns = RankmeMysql.columns.map(&:name)
        columns_to_update = columns - ["id", "steam", "name", "lastip"]
        columns_with_zero = columns_to_update.map { |c| [c, 0] }.to_h
        RankmeMysql.update_all columns_with_zero
      end
      session[:chosen_map] = session[:maps].sample
      session[:maps] = session[:maps] - [session[:chosen_map]]
      session[:chosen_maps] = [] if session[:chosen_maps].nil?
      session[:chosen_maps] << session[:chosen_map]
    end
    if params[:reset]
      session[:chosen_map] = nil
      session[:chosen_maps] = []
      columns = RankmeMysql.columns.map(&:name)
      columns_to_update = columns - ["id", "steam", "name", "lastip"]
      columns_with_zero = columns_to_update.map { |c| [c, 0] }.to_h
      RankmeMysql.update_all columns_with_zero
      init_maps
    end
  end

  def init_maps
    session[:maps] = Map.ativos.order('random()').pluck(:id)
  end

end
