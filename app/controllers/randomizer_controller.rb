require 'net/ssh'

class RandomizerController < ApplicationController
  before_action :authenticate_user

  def index
  end

  def open_map
    map = Map.find(RandomMap.last.map_id)
    Net::SSH.start('127.0.0.1', login_jogo, password: 's3nh4123', port: 19922) do| ssh |
      ssh.exec! "tmux send-keys 'changelevel #{map.sigla}' Enter"
    end
    flash[:success] = "Mapa mudou para #{map.nome} - #{map.sigla}!"
    redirect_to randomizer_url
  end

  def select
    RandomMap.create(map_id: params[:map_id])
    redirect_to randomizer_url
  end

  def raffle
    chosen_map = (Map.where(game_id: current_game.id).ativos.pluck(:id) - RandomMap.pluck(:map_id)).sample
    RandomMap.create(map_id: chosen_map) if chosen_map
    redirect_to randomizer_url
  end

  def reset
    RandomMap.destroy_all
    redirect_to randomizer_url
  end

  def start
    torneio_dia = Tournament.find_by(nome: "Torneio #{Date.today.to_s(:human)}")
    mapa = RandomMap.last.map.sigla
    if torneio_dia.nil?
      torneio_dia = Tournament.create(nome: "Torneio #{Date.today.to_s(:human)}", season_id: current_season.id)
      flash[:success] = "Torneio #{Date.today.to_s(:human)} e mapa iniciado com sucesso!"
    else
      flash[:success] = "Mapa iniciado com sucesso!"
    end
    Net::SSH.start('127.0.0.1', login_jogo, password: 's3nh4123', port: 19922) do| ssh |
      ssh.exec! "tmux send-keys 'tv_stoprecord' Enter"
      ssh.exec! "tmux send-keys 'sm plugins unload kento_rankme' Enter"
      ssh.exec! "tmux send-keys 'sm plugins unload rankme' Enter"
    end
    RankmeMysql.delete_all
    RankmeMysqlCsgo.delete_all
    Net::SSH.start('127.0.0.1', login_jogo, password: 's3nh4123', port: 19922) do| ssh |
      ssh.exec! "tmux send-keys 'mp_warmup_end' Enter"
      ssh.exec! "tmux send-keys 'mp_restartgame 2' Enter"
      ssh.exec! "tmux send-keys 'sm plugins load rankme' Enter"
      ssh.exec! "tmux send-keys 'sm plugins load kento_rankme' Enter"
      ssh.exec! "tmux send-keys 'tv_enable 1' Enter"
      nome_replay = Time.now.day.to_s.rjust(2, "0") + '_' + Time.now.month.to_s + '_' + Time.now.year.to_s + '_' + mapa
      ssh.exec! "tmux send-keys 'tv_record #{nome_replay}' Enter"
    end
    redirect_to randomizer_url
  end

  def finish
    Net::SSH.start('127.0.0.1', login_jogo, password: 's3nh4123', port: 19922) do| ssh |
      ssh.exec! "tmux send-keys 'tv_stoprecord' Enter"
    end
    finish_csgo if is_csgo?
    finish_css if is_css?
    redirect_to randomizer_url
  end

  def finish_csgo
    ActiveRecord::Base.transaction do
      # Consulta o torneio do dia
      torneio_dia = Tournament.find_by(nome: "Torneio #{Date.today.to_s(:human)}")
      # Cria o round com os dados de torneio e mapa
      chosen_map = RandomMap.last
      round = Round.create(tournament_id: torneio_dia.id, map_id: chosen_map.map_id, season_id: current_season.id)
      ###############################################################################################################
      maximo_jogado = RankmeMysqlCsgo.pluck("rounds_ct + rounds_tr").max
      # RankmeMysqlCsgo.where("rounds_ct + rounds_tr < ?", maximo_jogado).destroy_all
      maximo_ganhado = RankmeMysqlCsgo.pluck("ct_win + tr_win").max
      minimo_ganhado = RankmeMysqlCsgo.pluck("ct_win + tr_win").min
      array = RankmeMysqlCsgo.all.map{|r| { r.id => r.ct_win + r.tr_win }}
      time_vencedor = []
      time_perdedor = []
      array.each do |hash|
        hash.each do |k, v|
          if v == maximo_ganhado
            time_vencedor << k
          else
            time_perdedor << k
          end
        end
      end
      jogadores_time_vencedor = RankmeMysqlCsgo.where("id IN (?)", time_vencedor).pluck(:steam).sort
      jogadores_time_vencedor.map!{|j| j.split(":").last}
      # Pega todos os ids de usuário dos jogadores do time VENCEDOR
      ids_jogadores_time_vencedor = User.where(steam: jogadores_time_vencedor).pluck(:id).sort
      # Verificar quais os times existentes que esses jogadores participam
      ids_times_ja_criados = Team.joins(:players).where("players.user_id IN (?)", ids_jogadores_time_vencedor).pluck(:id).uniq.sort
      # Para cada time, consultar os jogadores do mesmo e comparar o resultado em forma de array com os ids do time atual
      salvar_novo_time = true
      time_vencedor = nil
      ids_times_ja_criados.each do |team_id|
        jogadores_desse_time = Team.find(team_id).users.pluck(:id).sort
        if jogadores_desse_time == ids_jogadores_time_vencedor
          time_vencedor = Team.find(team_id)
          salvar_novo_time = false
          break
        end
      end
      if salvar_novo_time
        time_vencedor = Team.create(nome: "Time #{helpers.criar_nome_time(ids_jogadores_time_vencedor)}")
      end
      Participant.create(team_id: time_vencedor.id, tournament_id: torneio_dia.id)
      jogadores_time_vencedor.each do |steam_jogador|
        # Identifica o jogador na tabela users pelo steam
        user = User.find_by(steam: steam_jogador)
        # Pega todos os dados desse jogador no mysql removendo o id
        unless user.nil?
          dados_mysql = RankmeMysqlCsgo.where("steam LIKE '%#{user.steam}'").last
          dados_tratados = dados_mysql.as_json.select {|k,v| k != 'id'}
          # Coloca o resto das informações no hash para salvar
          dados_tratados[:user_id] = user.id
          dados_tratados[:map_id] = chosen_map.map_id
          dados_tratados[:tournament_id] = torneio_dia.id
          dados_tratados[:round_id] = round.id
          dados_tratados[:team_id] = time_vencedor.id
          dados_tratados[:season_id] = current_season.id
          # Salva todos os dados do jogador que veio do mysql na tabela rankmes do sistema
          RankmeCsgo.create(dados_tratados)
          # Insere o jogador no time VENCEDOR
          Player.where(team_id: time_vencedor.id, user_id: user.id).first_or_create
        end
      end
      Winner.create(team_id: time_vencedor.id, round_id: round.id, placar: maximo_ganhado)
      ############################################################################################################
      jogadores_time_perdedor = RankmeMysqlCsgo.where("id IN (?)", time_perdedor).pluck(:steam).sort
      jogadores_time_perdedor.map!{|j| j.split(":").last}
      # Pega todos os ids de usuário dos jogadores do time PERDEDOR
      ids_jogadores_time_perdedor = User.where(steam: jogadores_time_perdedor).pluck(:id).sort
      # Verificar quais os times existentes que esses jogadores participam
      ids_times_ja_criados = Team.joins(:players).where("players.user_id IN (?)", ids_jogadores_time_perdedor).pluck(:id).uniq.sort
      # Para cada time, consultar os jogadores do mesmo e comparar o resultado em forma de array com os ids do time atual
      salvar_novo_time = true
      time_perdedor = nil
      ids_times_ja_criados.each do |team_id|
        jogadores_desse_time = Team.find(team_id).users.pluck(:id).sort
        if jogadores_desse_time == ids_jogadores_time_perdedor
          time_perdedor = Team.find(team_id)
          salvar_novo_time = false
          break
        end
      end
      if salvar_novo_time
        time_perdedor = Team.create(nome: "Time #{helpers.criar_nome_time(ids_jogadores_time_perdedor)}")
      end
      Participant.create(team_id: time_perdedor.id, tournament_id: torneio_dia.id)
      jogadores_time_perdedor.each do |steam_jogador|
        # Identifica o jogador na tabela users pelo steam
        user = User.find_by(steam: steam_jogador)
        # Pega todos os dados desse jogador no mysql removendo o id
        unless user.nil?
          dados_mysql = RankmeMysqlCsgo.where("steam LIKE '%#{user.steam}'").last
          dados_tratados = dados_mysql.as_json.select {|k,v| k != 'id'}
          # Coloca o resto das informações no hash para salvar
          dados_tratados[:user_id] = user.id
          dados_tratados[:map_id] = chosen_map.map_id
          dados_tratados[:tournament_id] = torneio_dia.id
          dados_tratados[:round_id] = round.id
          dados_tratados[:team_id] = time_perdedor.id
          dados_tratados[:season_id] = current_season.id
          # Salva todos os dados do jogador que veio do mysql na tabela rankmes do sistema
          RankmeCsgo.create(dados_tratados)
          # Insere o jogador no time PERDEDOR
          Player.where(team_id: time_perdedor.id, user_id: user.id).first_or_create
        end
      end
      Loser.create(team_id: time_perdedor.id, round_id: round.id, placar: minimo_ganhado)
    end
    flash[:success] = "Mapa finalizado com sucesso!"
  end

  def finish_css
    ActiveRecord::Base.transaction do
      # Consulta o torneio do dia
      torneio_dia = Tournament.find_by(nome: "Torneio #{Date.today.to_s(:human)}")
      # Verificar se houve algum vencedor
      vencedor_ct = RankmeMysql.find_by(ct_win: current_configuration.numero_partidas)
      vencedor_tr = RankmeMysql.find_by(tr_win: current_configuration.numero_partidas)
      # Se existir vencedor da partida
      if vencedor_ct || vencedor_tr
        # Cria o round com os dados de torneio e mapa
        chosen_map = RandomMap.last
        round = Round.create(tournament_id: torneio_dia.id, map_id: chosen_map.map_id, season_id: current_season.id)
        # Pega todos os códigos da steam dos jogadores do time CT
        jogadores_time_ct = RankmeMysql.where("rounds_ct > 0").pluck(:steam).sort
        jogadores_time_ct.map!{|j| j.split(":").last}
        # Pega todos os ids de usuário dos jogadores do time CT
        ids_jogadores_time_ct = User.where(steam: jogadores_time_ct).pluck(:id).sort
        # Verificar quais os times existentes que esses jogadores participam
        ids_times_ja_criados = Team.joins(:players).where("players.user_id IN (?)", ids_jogadores_time_ct).pluck(:id).uniq.sort
        # Para cada time, consultar os jogadores do mesmo e comparar o resultado em forma de array com os ids do time atual
        salvar_novo_time = true
        time_ct = nil
        ids_times_ja_criados.each do |team_id|
          jogadores_desse_time = Team.find(team_id).users.pluck(:id).sort
          if jogadores_desse_time == ids_jogadores_time_ct
            time_ct = Team.find(team_id)
            salvar_novo_time = false
            break
          end
        end
        if salvar_novo_time
          time_ct = Team.create(nome: "Time #{helpers.criar_nome_time(ids_jogadores_time_ct)}")
          Participant.create(team_id: time_ct.id, tournament_id: torneio_dia.id)
        end
        jogadores_time_ct.each do |steam_jogador|
          # Identifica o jogador na tabela users pelo steam
          user = User.find_by(steam: steam_jogador)
          # Pega todos os dados desse jogador no mysql removendo o id
          dados_mysql = RankmeMysql.where("steam LIKE '%#{user.steam}'").last
          dados_tratados = dados_mysql.as_json.select {|k,v| k != 'id'}
          # Coloca o resto das informações no hash para salvar
          dados_tratados[:user_id] = user.id
          dados_tratados[:map_id] = chosen_map.map_id
          dados_tratados[:tournament_id] = torneio_dia.id
          dados_tratados[:round_id] = round.id
          dados_tratados[:team_id] = time_ct.id
          dados_tratados[:season_id] = current_season.id
          # Salva todos os dados do jogador que veio do mysql na tabela rankmes do sistema
          Rankme.create(dados_tratados)
          # Insere o jogador no time CT
          Player.where(team_id: time_ct.id, user_id: user.id).first_or_create
        end
        # Pega todos os códigos da steam dos jogadores do time TR
        jogadores_time_tr = RankmeMysql.where("rounds_tr > 0").pluck(:steam)
        jogadores_time_tr.map!{|j| j.split(":").last}
        # Pega todos os ids de usuário dos jogadores do time TR
        ids_jogadores_time_tr = User.where(steam: jogadores_time_tr).pluck(:id).sort
        # Verificar quais os times existentes que esses jogadores participam
        ids_times_ja_criados = Team.joins(:players).where("players.user_id IN (?)", ids_jogadores_time_tr).pluck(:id).uniq.sort
        # Para cada time, consultar os jogadores do mesmo e comparar o resultado em forma de array com os ids do time atual
        salvar_novo_time = true
        time_tr = nil
        ids_times_ja_criados.each do |team_id|
          jogadores_desse_time = Team.find(team_id).users.pluck(:id).sort
          if jogadores_desse_time == ids_jogadores_time_tr
            time_tr = Team.find(team_id)
            salvar_novo_time = false
            break
          end
        end
        if salvar_novo_time
          time_tr = Team.create(nome: "Time #{helpers.criar_nome_time(ids_jogadores_time_tr)}")
          Participant.create(team_id: time_tr.id, tournament_id: torneio_dia.id)
        end
        jogadores_time_tr.each do |steam_jogador|
          # Identifica o jogador na tabela users pelo steam
          user = User.find_by(steam: steam_jogador)
          # Pega todos os dados desse jogador no mysql removendo o id
          dados_mysql = RankmeMysql.where("steam LIKE '%#{user.steam}'").last
          dados_tratados = dados_mysql.as_json.select {|k,v| k != 'id'}
          # Coloca o resto das informações no hash para salvar
          dados_tratados[:user_id] = user.id
          dados_tratados[:map_id] = chosen_map.map_id
          dados_tratados[:tournament_id] = torneio_dia.id
          dados_tratados[:round_id] = round.id
          dados_tratados[:team_id] = time_tr.id
          dados_tratados[:season_id] = current_season.id
          # Salva todos os dados do jogador que veio do mysql na tabela rankmes do sistema
          Rankme.create(dados_tratados)
          # Insere o jogador no time TR
          Player.where(team_id: time_tr.id, user_id: user.id).first_or_create
        end
        # Se o vencedor foi o time CT
        if vencedor_ct
          Winner.create(team_id: time_ct.id, round_id: round.id, placar: current_configuration.numero_partidas, lado: 'ct')
          # Pega o número maior de vitorias dos TR
          vitorias_tr = RankmeMysql.where("tr_win > 0").pluck(:tr_win).max
          Loser.create(team_id: time_tr.id, round_id: round.id, placar: vitorias_tr, lado: 't')
        end
        # Se o vencedor foi o time TR
        if vencedor_tr
          Winner.create(team_id: time_tr.id, round_id: round.id, placar: current_configuration.numero_partidas, lado: 't')
          # Pega o número maior de vitorias dos CT
          vitorias_ct = RankmeMysql.where("ct_win > 0").pluck(:ct_win).max
          Loser.create(team_id: time_ct.id, round_id: round.id, placar: vitorias_ct, lado: 'ct')
        end
        flash[:success] = "Mapa finalizado com sucesso!"
      else
        # Se não existir vencedor da partida, só retorna uma mensagem
        flash[:warning] = "Mapa não teve um vencedor. Não foi gravado os dados!"
      end
    end
  end

  private

  def login_jogo
    current_game.login
  end

  def is_csgo?
    current_game.sigla == "CSGO"
  end

  def is_css?
    current_game.sigla == "CSS"
  end

end
