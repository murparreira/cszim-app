require 'net/ssh'

class ManagerController < ApplicationController
  before_action :authenticate_user

  def index
  end

  def open_map
    map = Map.find(RandomMap.last.map_id)
    Net::SSH.start(current_configuration.server_name_or_ip, current_configuration.server_user, password: current_configuration.server_password, port: current_configuration.server_port) do| ssh |
      ssh.exec! "tmux send-keys 'changelevel #{map.sigla}' Enter"
    end
    flash[:success] = "Mapa mudou para #{map.nome} - #{map.sigla}!"
    redirect_to manager_url
  rescue Errno::ECONNREFUSED
    flash[:warning] = "Conexão recusada com o servidor!"
    redirect_to manager_url
  end

  def select
    RandomMap.create(map_id: params[:map_id])
    redirect_to manager_url
  end

  def raffle
    chosen_map = (Map.where(game_id: current_game.id).ativos.pluck(:id) - RandomMap.pluck(:map_id)).sample
    RandomMap.create(map_id: chosen_map) if chosen_map
    redirect_to manager_url
  end

  def reset
    RandomMap.destroy_all
    redirect_to manager_url
  end

  def start
    if current_configuration.version.downcase == 'v1'
      start_v1
    else
      start_v2
    end
  end

  def finish
    if current_configuration.version.downcase == 'v1'
      finish_v1
    else
      finish_v2
    end
  end

  def start_v1
    torneio_dia = Tournament.find_by(nome: "Torneio #{Date.today.to_s(:human)}")
    mapa = RandomMap.last.map.sigla
    if torneio_dia.nil?
      torneio_dia = Tournament.create(nome: "Torneio #{Date.today.to_s(:human)}", season_id: current_season.id)
      flash[:success] = "Torneio #{Date.today.to_s(:human)} e mapa iniciado com sucesso!"
    else
      flash[:success] = "Mapa iniciado com sucesso!"
    end
    Net::SSH.start(current_configuration.server_name_or_ip, current_configuration.server_user, password: current_configuration.server_password, port: current_configuration.server_port) do| ssh |
      ssh.exec! "tmux send-keys 'tv_stoprecord' Enter"
      ssh.exec! "tmux send-keys 'sm plugins unload kento_rankme' Enter"
      ssh.exec! "tmux send-keys 'sm plugins unload rankme' Enter"
    end
    RankmeMysqlCsgo.delete_all
    Net::SSH.start(current_configuration.server_name_or_ip, current_configuration.server_user, password: current_configuration.server_password, port: current_configuration.server_port) do| ssh |
      ssh.exec! "tmux send-keys 'mp_warmup_end' Enter"
      ssh.exec! "tmux send-keys 'mp_restartgame 2' Enter"
      ssh.exec! "tmux send-keys 'sm plugins load rankme' Enter"
      ssh.exec! "tmux send-keys 'sm plugins load kento_rankme' Enter"
      ssh.exec! "tmux send-keys 'tv_enable 1' Enter"
      nome_replay = Time.now.day.to_s.rjust(2, "0") + '_' + Time.now.month.to_s + '_' + Time.now.year.to_s + '_' + mapa
      ssh.exec! "tmux send-keys 'tv_record #{nome_replay}' Enter"
    end
    redirect_to manager_url
  rescue Errno::ECONNREFUSED
    flash[:warning] = "Conexão recusada com o servidor!"
    redirect_to manager_url
  end

  def finish_v1
    Net::SSH.start(current_configuration.server_name_or_ip, current_configuration.server_user, password: current_configuration.server_password, port: current_configuration.server_port) do| ssh |
      ssh.exec! "tmux send-keys 'tv_stoprecord' Enter"
    end
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
      ids_jogadores_time_vencedor = User.where(old_steam: jogadores_time_vencedor).pluck(:id).sort
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
        user = User.find_by(old_steam: steam_jogador)
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
      ids_jogadores_time_perdedor = User.where(old_steam: jogadores_time_perdedor).pluck(:id).sort
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
        user = User.find_by(old_steam: steam_jogador)
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
    redirect_to manager_url
  rescue Errno::ECONNREFUSED
    flash[:warning] = "Conexão recusada com o servidor!"
    redirect_to manager_url
  end

  def start_v2
    torneio_dia = Tournament.find_by(nome: "Torneio #{Date.today.to_s(:human)}")
    random_map = RandomMap.last.map
    if torneio_dia.nil?
      torneio_dia = Tournament.create(nome: "Torneio #{Date.today.to_s(:human)}", season_id: current_season.id)
      flash[:success] = "Torneio #{Date.today.to_s(:human)} e mapa iniciado com sucesso!"
    else
      flash[:success] = "Mapa iniciado com sucesso!"
    end
    Net::SSH.start(current_configuration.server_name_or_ip, current_configuration.server_user, password: current_configuration.server_password, port: current_configuration.server_port) do| ssh |
      ssh.exec! "tmux send-keys 'tv_stoprecord' Enter"
      ssh.exec! "tmux send-keys 'sm plugins unload kento_rankme' Enter"
      ssh.exec! "tmux send-keys 'sm plugins unload rankme' Enter"
    end
    Net::SSH.start(current_configuration.server_name_or_ip, current_configuration.server_user, password: current_configuration.server_password, port: current_configuration.server_port) do| ssh |
      ssh.exec! "tmux send-keys 'mp_warmup_end' Enter"
      ssh.exec! "tmux send-keys 'mp_restartgame 2' Enter"
      ssh.exec! "tmux send-keys 'sm plugins load rankme' Enter"
      ssh.exec! "tmux send-keys 'sm plugins load kento_rankme' Enter"
      ssh.exec! "tmux send-keys 'tv_enable 1' Enter"
      nome_replay = Time.now.day.to_s.rjust(2, "0") + '_' + Time.now.month.to_s + '_' + Time.now.year.to_s + '_' + random_map.sigla
      ssh.exec! "tmux send-keys 'tv_record #{nome_replay}' Enter"
      Demo.create(
        nome: nome_replay,
        map_id: random_map.id
      )
    end
    redirect_to manager_url
  rescue Errno::ECONNREFUSED
    flash[:warning] = "Conexão recusada com o servidor!"
    redirect_to manager_url
  end

  def finish_v2
    demo = Demo.last
    Net::SSH.start(current_configuration.server_name_or_ip, current_configuration.server_user, password: current_configuration.server_password, port: current_configuration.server_port) do| ssh |
      ssh.exec! "tmux send-keys 'tv_stoprecord' Enter"
    end
    # Demo.create(nome: '06_2_2023_de_inferno', map_id: Map.find_by(sigla: 'de_inferno').id)
    # Demo.create(nome: '08_2_2023_de_boyard', map_id: Map.find_by(sigla: 'de_boyard').id)
    # Demo.create(nome: '08_2_2023_de_chalice', map_id: Map.find_by(sigla: 'de_chalice').id)
    # Demo.create(nome: '08_2_2023_de_seaside', map_id: Map.find_by(sigla: 'de_seaside').id)
    # Demo.create(nome: '09_2_2023_de_stmarc', map_id: Map.find_by(sigla: 'de_stmarc').id)
    # Demo.all.each do |demo|
    #   ParserJob.set(queue: :default, wait: 5.seconds, priority: 10).perform_later(demo.id)
    # end
    ParserJob.set(queue: :default, wait: 5.seconds, priority: 10).perform_later(demo.id)
    flash[:success] = "Mapa finalizado com sucesso!"
    redirect_to manager_url
  rescue Errno::ECONNREFUSED
    flash[:warning] = "Conexão recusada com o servidor!"
    redirect_to manager_url
  end

end
