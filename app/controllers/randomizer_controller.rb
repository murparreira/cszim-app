require 'net/ssh'

class RandomizerController < ApplicationController

  def index
  end

  def open_map
    map = Map.find(RandomMap.last.map_id)
    Net::SSH.start('201.25.106.82', 'cssserver', :password => 's3nh4123') do| ssh |
      ssh.exec! "tmux send-keys 'changelevel #{map.sigla}' Enter"
    end
    flash[:success] = "Mapa mudou para #{map.nome} - #{map.sigla}!"
    redirect_to randomizer_url
  end

  def raffle
    chosen_map = (Map.pluck(:id) - RandomMap.pluck(:map_id)).sample
    RandomMap.create(map_id: chosen_map)
    redirect_to randomizer_url
  end

  def reset
    RandomMap.destroy_all
    columns = RankmeMysql.columns.map(&:name)
    columns_to_update = columns - ["id", "steam", "name", "lastip"]
    columns_with_zero = columns_to_update.map { |c| [c, 0] }.to_h
    RankmeMysql.all.update columns_with_zero
    redirect_to randomizer_url
  end

  def start
    @torneio_dia = Tournament.find_by(nome: "Torneio #{Date.today.to_s(:human)}")
    if @torneio_dia.nil?
      @torneio_dia = Tournament.create(nome: "Torneio #{Date.today.to_s(:human)}")
      @ct_team = Team.create(nome: "Time 1 CT #{Date.today.to_s(:human)}")
      @tr_team = Team.create(nome: "Time 2 TR #{Date.today.to_s(:human)}")
      Participant.create(team_id: @ct_team.id, tournament_id: @torneio_dia.id)
      Participant.create(team_id: @tr_team.id, tournament_id: @torneio_dia.id)
      flash[:success] = "Torneio #{Date.today.to_s(:human)} e mapa iniciado com sucesso!"
    else
      flash[:success] = "Mapa iniciado com sucesso!"
    end
    columns = RankmeMysql.columns.map(&:name)
    columns_to_update = columns - ["id", "steam", "name", "lastip"]
    columns_with_zero = columns_to_update.map { |c| [c, 0] }.to_h
    RankmeMysql.all.update columns_with_zero
    redirect_to randomizer_url
  end

  def finish
    chosen_map = RandomMap.last
    @torneio_dia = Tournament.find_by(nome: "Torneio #{Date.today.to_s(:human)}")
    @rankme_mysql_ct = RankmeMysql.where('ct_win = 7').first
    @rankme_mysql_tr = RankmeMysql.where('tr_win = 7').first
    if @rankme_mysql_ct.try(:ct_win) == 7 || @rankme_mysql_tr.try(:tr_win) == 7
      round = Round.create(tournament_id: @torneio_dia.id, map_id: chosen_map.map_id)
      ct_team = Team.find_by(nome: "Time 1 CT #{Date.today.to_s(:human)}")
      tr_team = Team.find_by(nome: "Time 2 TR #{Date.today.to_s(:human)}")
      if @rankme_mysql_ct.try(:ct_win) == 7
        rankme_mysql_tr_win = RankmeMysql.where('tr_win > 0').first
        Winner.create(team_id: ct_team.id, round_id: round.id, placar: @rankme_mysql_ct.ct_win, lado: 'ct')
        Loser.create(team_id: tr_team.id, round_id: round.id, placar: rankme_mysql_tr_win.tr_win, lado: 't')
      elsif @rankme_mysql_tr.try(:tr_win) == 7
        rankme_mysql_ct_win = RankmeMysql.where('ct_win > 0').first
        Winner.create(team_id: tr_team.id, round_id: round.id, placar: @rankme_mysql_tr.tr_win, lado: 't')
        Loser.create(team_id: ct_team.id, round_id: round.id, placar: rankme_mysql_ct_win.ct_win, lado: 'ct')
      end
      User.all.each do |u|
        if u.steam.present?
          @rankme_mysql = RankmeMysql.find_by(:steam => u.steam)
          if @rankme_mysql.present?
            @ct_team = Team.find_by(nome: "Time 1 CT #{Date.today.to_s(:human)}")
            @tr_team = Team.find_by(nome: "Time 2 TR #{Date.today.to_s(:human)}")
            if @rankme_mysql.ct_win.to_i > 0 || @rankme_mysql.tr_win.to_i > 0
              rankme_attributes = @rankme_mysql.as_json.select{|k,v| k != 'id'}
              if @rankme_mysql.ct_win.to_i == 7
                rankme_attributes[:team_id] = @ct_team.id
                Player.where(team_id: @ct_team.id, user_id: u.id).first_or_create
              else
                rankme_attributes[:team_id] = @tr_team.id
                Player.where(team_id: @tr_team.id, user_id: u.id).first_or_create
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
      end
      columns = RankmeMysql.columns.map(&:name)
      columns_to_update = columns - ["id", "steam", "name", "lastip"]
      columns_with_zero = columns_to_update.map { |c| [c, 0] }.to_h
      RankmeMysql.all.update columns_with_zero
      flash[:warning] = "Mapa finalizado com sucesso!"
    else
      flash[:warning] = "Mapa não teve um vencedor. Não foi gravado os dados!"
    end
    redirect_to randomizer_url
  end

end
